LinkedIn Search
===============

This is the Rails 4 application providing [LinkedIn Search](http://linkedin.algolia.com). It's based on [algoliasearch-client-ruby](https://github.com/algolia/algoliasearch-client-ruby) and [omniauth-linkedin](https://github.com/skorks/omniauth-linkedin).

Index settings
----------------------

```ruby
Algolia.init application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY']
INDEX = Algolia::Index.new("linkedin_#{Rails.env}")
INDEX.set_settings({
  attributesToIndex: ['last_name', 'first_name', 'unordered(headline)', 'unordered(industry)', 'unordered(location)', 'unordered(positions.company.name)'],
  customRanking: ['desc(num_connections)', 'asc(last_name)'],
  attributesForFaceting: ['industry', 'location', 'positions.company.name']
})
```

Record definition
------------------

```ruby
FIELDS = ["id", "first-name", "last-name", "headline", "industry", "picture-url",
 "public-profile-url", "location", "num-connections", "positions"]

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
    _tags: [ uid ] # used for security
  }
end
```

Secure indexing
----------------

Each record (connection) is tagged with its owner id (Your LinkedIn UID) and we use a per-user [generated secured API key](http://www.algolia.com/doc#SecurityUser) to call Algolia's REST API.

```ruby
@secured_api_key = Algolia.generate_secured_api_key(ENV['ALGOLIA_API_KEY_SEARCH_ONLY'], current_user.uid)
```

```js
var algolia = new AlgoliaSearch('#{ENV['ALGOLIA_APPLICATION_ID']}', '#{@secured_api_key}');
algolia.setSecurityTags('#{current_user.uid}');
```
