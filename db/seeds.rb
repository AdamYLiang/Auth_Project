
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Cat.destroy_all
User.destroy_all
CatRentalRequest.destroy_all

10.times do
  u = User.create!(username: Faker::Name.name, password: "password")
  Cat.create!(
    user_id: u.id,
    name: Faker::Hipster.word,
    color: Cat::CAT_COLORS.sample,
    sex: ["M", "F"].sample,
    description: Faker::Hipster.sentence,
    birth_date: Faker::Date.between(10.years.ago, Date.today)
  )
end