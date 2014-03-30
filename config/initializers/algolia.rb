Algolia.init application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY']
INDEX = Algolia::Index.new("linkedin_#{Rails.env}")
INDEX.set_settings({
  attributesToIndex: ['last_name', 'first_name', 'unordered(headline)', 'unordered(industry)', 'unordered(location)', 'unordered(positions.company.name)'],
  customRanking: ['desc(num_connections)', 'asc(last_name)'],
  attributesForFaceting: ['industry', 'location', 'positions.company.name']
})
