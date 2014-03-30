INDUSTRIES = ['Computer Software', 'Information Technology and Services', 'Internet', 'Computer & Network Security', 'Research', 'Management Consulting', 'Marketing and Advertising', 'Online Media', 'Financial Services', 'Investment Banking']
INDUSTRIES_WEIGHT = [233, 131, 57, 16, 13, 8, 8, 7, 6, 5]

INDEX.add_objects(1500.times.map do |i|
  {
    objectID: "demo_#{i}",
    first_name: Random.firstname,
    last_name: Random.lastname,
    headline: Faker::Name.title,
    industry: INDUSTRIES[INDUSTRIES_WEIGHT.roulette],
    location: "#{Random.city}, #{Random.country}",
    picture_url: nil,
    url: '#',
    num_connections: 50 + rand(451),
    positions: rand(2).times.map {
      {
        company: {
          name: Faker::Company.name,
          industry: INDUSTRIES[INDUSTRIES_WEIGHT.roulette]
        },
        is_current: rand(3) < 2,
        start_date: 2005 + rand(9),
        summary: nil,
        title: nil
      }
    },
    _tags: [ 'demo' ]
  }
end)