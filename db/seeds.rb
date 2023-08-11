require 'faker'

# Create 5 teams
team_names = (1..5).map { |i| { name: Faker::Team.name } }
teams = Team.create(team_names)

# Create 20 members with random values for each field
20.times do
  team = teams.sample

  Member.create(
    first_name: Faker::Name.unique.first_name,
    last_name: Faker::Name.unique.last_name,
    team: team,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: Faker::Address.country
  )
end

# Create 5 projects
5.times do
  Project.create(name: Faker::App.name)
end

# Assign members to the projects
Project.all.each_with_index do |project, index|
  project.members << Member.all.limit(2).offset(index*2)
end