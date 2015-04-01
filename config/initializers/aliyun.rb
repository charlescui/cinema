config = {
    :aliyun_access_id => Rails.application.secrets.aliyun_access_id,
    :aliyun_access_key => Rails.application.secrets.aliyun_access_key,
    :aliyun_bucket => Rails.application.secrets.aliyun_bucket,
    :aliyun_area => Rails.application.secrets.aliyun_area
}

$oss = ::Aliyun::Connection.new(config)