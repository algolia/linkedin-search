class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  protected
    DEFAULT_HIPCHAT_PARAMS = {
      color: :green, room: ENV['HIPCHAT_ROOM'], notify: false, format: 'html'
    }
    def hipchat_notify!(message, params = {})
      params = DEFAULT_HIPCHAT_PARAMS.merge(params)
      escaped_msg = (params[:mentions] ? "@#{params[:mentions].join(' @')} " : '') + (params[:format] == 'text' ? message : CGI::escapeHTML(message).to_s)
      HipChat::Client.new(ENV['HIPCHAT_API_TOKEN'])[params[:room]].send('linkedin', escaped_msg, color: params[:color], notify: params[:notify], message_format: params[:format])
    rescue
      # not fatal
    end

  private
    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Exception => e
        nil
      end
    end

    def user_signed_in?
      return true if current_user
    end

    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
    end

end
