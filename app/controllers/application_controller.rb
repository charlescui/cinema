class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user_session, :current_user, :current_eye_session, :current_eye

  def render_json(json = {})
    render :text => JSON.generate({:status => 0, :msg => "success."}.merge(json))
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def current_eye_session
    return @current_eye_session if defined?(@current_eye_session)
    @current_eye_session = EyeSession.find
  end

  def current_eye
    return @current_eye if defined?(@current_eye)
    @current_eye = current_eye_session && current_eye_session.eye
  end
end
