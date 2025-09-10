# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# encoding: utf-8


1.times do
  User.create!(
    email_address: 'nguyenbao.nta@gmail.com',
    password: '1234',
    name: 'NGUYEN DAO GIA BAO',
    user_name: Faker::Alphanumeric.alpha(number: 6),
    role: 1,
    active: 1
  )
end

100.times do
  Player.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 35),
    email: Faker::Internet.email,
    password: '1234',
    point: rand(10..500),
    point_plus: rand(10..200),
    created_by_id: 1
  )
end