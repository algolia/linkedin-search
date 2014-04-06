class SessionsController < ApplicationController

  def new
    redirect_to '/auth/linkedin'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'], :uid => auth['uid'].to_s).first || User.create_with_omniauth(auth)
    hipchat_notify! "#{user.name} (#{user.email}) signed in", color: :green, notify: true
    user.delay.crawl_connections!(auth.credentials.token, auth.credentials.secret)
    reset_session
    session[:user_id] = user.id
    if user.email.blank?
      redirect_to edit_user_path(user), :alert => "Please enter your email address."
    else
      redirect_to root_url, :notice => 'Signed in!'
    end

  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

  def infos
    render json: { nonSearchableUsers: current_user.try(:non_searchable_counter) }
  end

end
