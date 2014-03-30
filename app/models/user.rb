class User < ActiveRecord::Base
  validates_presence_of :name

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
    end
  end

  FIELDS = ["id", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "num-connections", "positions"]

  def crawl_connections!(token, secret)
    client = LinkedIn::Client.new(ENV['OMNIAUTH_PROVIDER_KEY'], ENV['OMNIAUTH_PROVIDER_SECRET'])
    client.authorize_from_access(token, secret)
    INDEX.add_object build_algolia_object(client.profile(fields: FIELDS))
    INDEX.add_objects client.connections(fields: FIELDS).all.map { |c| build_algolia_object(c) }
  end

  private
  def build_algolia_object(c)
    {
      objectID: "#{uid}_#{c.id}",
      first_name: c.first_name,
      last_name: c.last_name,
      headline: c.headline,
      industry: c.industry,
      location: c.location.try(:name),
      picture_url: c.picture_url,
      url: c.public_profile_url,
      num_connections: c.num_connections,
      positions: (c.positions.try(:all) || []).map { |p|
        {
          company: p.company.to_h,
          is_current: p.is_current,
          start_date: p.start_date.to_h,
          summary: p.summary,
          title: p.title
        }
      },
      _tags: [ uid ]
    }
  end

end
