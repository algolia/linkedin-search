class WelcomeController < ApplicationController
  def new
    @secured_api_key = Algolia.generate_secured_api_key(ENV['ALGOLIA_API_KEY_SEARCH_ONLY'], current_user.uid) if current_user
  end

  def demo
    @tag = 'demo'
    @secured_api_key = Algolia.generate_secured_api_key(ENV['ALGOLIA_API_KEY_SEARCH_ONLY'], @tag)
    render action: :new
  end
end
