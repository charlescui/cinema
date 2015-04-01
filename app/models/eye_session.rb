class EyeSession < Authlogic::Session::Base
    single_access_allowed_request_types :any
end