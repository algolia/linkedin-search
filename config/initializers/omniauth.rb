Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV['OMNIAUTH_PROVIDER_KEY'], ENV['OMNIAUTH_PROVIDER_SECRET']
end
