class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
        t.string    :login,               :null => false                # 可选，可以用email来代替它，或者同时使用两者。
        t.string    :email,               :null => false                # 可选，可以用login来代替它，或者同时使用两者。
        t.string    :crypted_password,    :null => false                # 可选，但强烈建议加上。
        t.string    :password_salt,       :null => false                # 可选，但强烈建议加上。
        t.string    :persistence_token,   :null => false                # 必选
        t.string    :single_access_token, :null => false                # 可选，详见Authlogic::Session::Params
        t.string    :perishable_token,    :null => false                # 可选，详见Authlogic::Session::Perishability

        # Magic columns，就像ActiveRecord的created_at和updated_at一样，这些字段由Authlogic自动维护。
        t.integer   :login_count,         :null => false, :default => 0 # 可选，详见Authlogic::Session::MagicColumns
        t.integer   :failed_login_count,  :null => false, :default => 0 # 可选，详见Authlogic::Session::MagicColumns
        t.datetime  :last_request_at                                    # 可选，详见Authlogic::Session::MagicColumns
        t.datetime  :current_login_at                                   # 可选，详见Authlogic::Session::MagicColumns
        t.datetime  :last_login_at                                      # 可选，详见Authlogic::Session::MagicColumns
        t.string    :current_login_ip                                   # 可选，详见Authlogic::Session::MagicColumns
        t.string    :last_login_ip                                      # 可选，详见Authlogic::Session::MagicColumns

      t.timestamps null: false
    end
  end
end
