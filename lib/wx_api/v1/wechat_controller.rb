# -*- coding: utf-8 -*-

=begin
    <xml>
        <ToUserName><![CDATA[gh_35257627f651]]></ToUserName>
        <FromUserName><![CDATA[oq3rujgaXEyyh5A8XfqvHPCD8Le4]]></FromUserName>
        <CreateTime>1374820239</CreateTime>
        <MsgType><![CDATA[text]]></MsgType>
        <Content><![CDATA[A]]></Content>
        <MsgId>5904807964383903819</MsgId>
    </xml>  
=end

module WxApi::V1::WechatController
    TEXT_TEMPLATE = ERB.new <<-DOC
        <xml>
            <ToUserName><![CDATA[<%= xml["xml"]["FromUserName"] %>]]></ToUserName>
            <FromUserName><![CDATA[<%= xml["xml"]["ToUserName"] %>]]></FromUserName>
            <CreateTime><%= Time.now.to_i %></CreateTime>
            <MsgType><![CDATA[text]]></MsgType>
            <Content><![CDATA[<%= xml["xml"]["Content"] %>]]></Content>
            <FuncFlag>0</FuncFlag>
        </xml>
    DOC

    NEWS_TEMPLATE = ERB.new <<-DOC
        <xml>
            <ToUserName><![CDATA[<%= xml["xml"]["FromUserName"] %>]]></ToUserName>
            <FromUserName><![CDATA[<%= xml["xml"]["ToUserName"] %>]]></FromUserName>
            <CreateTime><%= Time.now.to_i %></CreateTime>
            <MsgType><![CDATA[news]]></MsgType>
            <ArticleCount><%= xml["xml"]["items"].size %></ArticleCount>
            <Articles>
                <% xml["xml"]["items"].each do |item| %>
                <item>
                    <Title><![CDATA[<%= item['title'] %>]]></Title> 
                    <Description><![CDATA[<%= item['description'] %>]]></Description>
                    <PicUrl><![CDATA[<%= item['picurl'] %>]]></PicUrl>
                    <Url><![CDATA[<%= redirect_logto item['url'] %>]]></Url>
                </item>
                <% end %>
            </Articles>
        </xml> 
    DOC

    # 图文列表最大10个
    NEWS_TEMPLATE_ITEMSCOUNT = 10

    def self.registered(app)

        #wechat platform adapter
        #1.perform sanity check on Get request
        #2.receive and process user data on Post request

        app.get '/wechat' do
            check_signature
        end

        app.post '/wechat' do
            str = request.body.read
            @xml = Hash.from_xml(str)
            #set current_user first
            current_user(@xml)
            #handle every type of wechat request
            content_type 'text/xml'
            handle_wechat(@xml).tap{|s| Rails.logger.info(s)}
        end

        app.helpers do
            #validate this visit
            def check_signature 
                token = Rails.application.secrets.wx_app_token
                signature = params[:signature]
                timestamp = params[:timestamp]
                nonce = params[:nonce]
                echostr = params[:echostr]
                
                if signature.nil? || timestamp.nil? || nonce.nil? || echostr.nil?
                    halt 403, {'Content-Type' => 'text/plain'}, "forbbiden"
                else
                    auth_arr = [token, timestamp, nonce].sort
                    if Digest::SHA1.hexdigest(auth_arr.join) == signature
                        return echostr
                    else
                        halt 403, {'Content-Type' => 'text/plain'}, "forbbiden"
                    end
                end
            end

            def current_user(xml=nil)
                @current_user ||= find_or_regist_user(xml)
            end

            def find_or_regist_user(xml)
                name = xml["xml"]["FromUserName"]
                login = wx_login_name(xml)
                user = User.where(:login => login).first
                unless user
                    user = User.new(:login => login,
                        :name => name,
                        :password => login,
                        :password_confirmation => login
                    )
                    user.save!
                end
                user
            end

            def wx_login_name(xml)
                "wx_#{xml["xml"]["FromUserName"]}"
            end

            def handle_wechat(xml)
                case xml["xml"]["MsgType"]
                when 'text'
                    handle_wechat_text(xml)
                when 'image'
                    handle_wechat_image(xml)
                when 'location'
                    handle_wechat_location(xml)
                when 'link'
                    handle_wechat_link(xml)
                when 'event'
                    handle_wechat_event(xml)
                end
            end

            # 打开网页版
            def handle_wechat_text_wy(xml)
                xml["xml"]["Content"] = "#{request.scheme}://#{request.host_with_port}/wx/portal/demo?user_credentials=kjpmdxnO2xSRQWhiYVXY&eye_id=1"
                #generate out put response with @xml and template
                TEXT_TEMPLATE.result(binding)
            end

            # 帮助说明文案
            def handle_wechat_text_help(xml)
                xml["xml"]["Content"] = help_text
                #generate out put response with @xml and template
                TEXT_TEMPLATE.result(binding)
            end

            # 绑定页面入口
            def handle_wechat_text_bind_entry(xml)
                xml["xml"]["Content"] = bind_text
                #generate out put response with @xml and template
                TEXT_TEMPLATE.result(binding)
            end

            def handle_wechat_text(xml)
                # 先通过文字匹配条件来检测一遍
                # 如果匹配，直接返回文案
                WxPatternText.all.each do |x|
                    if x.pattern == xml["xml"]["Content"]
                        xml["xml"]["Content"] = x.content
                        return TEXT_TEMPLATE.result(binding)
                    end
                end

                # 先通过正则匹配条件来检测一遍
                # 如果匹配，直接返回文案
                WxPatternRegular.all.each do |x|
                    reg = Regexp.new(x.pattern, 'i')
                    if reg.match(xml["xml"]["Content"])
                        xml["xml"]["Content"] = x.content
                        return TEXT_TEMPLATE.result(binding)
                    end
                end

                case xml["xml"]["Content"]
                when /^(help)$/i, /^帮助$/
                    handle_wechat_text_help(xml)
                when '?', '？'
                    handle_wechat_text_help(xml)
                when /^(\w+)$/
                    handle_wechat_text_media_info(xml, $1)
                else
                    handle_wechat_text_media_info(xml, xml["xml"]["Content"])
                end
            end

            def bind_text
                "<a href='#{request.scheme}://#{request.host_with_port}/wx/bind_ui?user_credentials=#{current_user.single_access_token}'>点此看教程并绑定机顶盒</a>"
            end

            def help_text
                <<-HELP
随时听候您的吩咐，
如果有不明白的地方，
请输入帮助获取说明，
祝您使用愉快！

需要观看演示，请点击此处：
<a href='#{request.scheme}://#{request.host_with_port}/wx/portal/demo?user_credentials=#{current_user(@xml).single_access_token}&eye_id=1'>演示地址</a>
                HELP
            end

            def handle_wechat_image(xml)
                xml
            end

            def handle_wechat_location(xml)
                xml
            end

            def handle_wechat_link(xml)
                xml
            end

            def handle_wechat_event(xml)
                case xml['xml']['Event']
                when 'subscribe'
                    handle_wechat_text_help(xml)
                when 'unsubscribe'
                when 'CLICK'
                    
                end
            end

        end

    end
end
