Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV['OMNIAUTH_PROVIDER_KEY'], ENV['OMNIAUTH_PROVIDER_SECRET'], scope: 'r_basicprofile r_emailaddress r_network'
end
