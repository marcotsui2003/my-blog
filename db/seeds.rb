# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Recipe.delete_all
Ingredient.delete_all
Comment.delete_all
Reply.delete_all
Authorization.delete_all



#12 users, 5 recipes each, each recipes has

peter = User.create(email: "peter@123.com", password: "123456", password_confirmation:"123456")
mary = User.create(email: "mary@123.com", password: "123456", password_confirmation:"123456")
david = User.create(email: "david@123.com", password: "123456", password_confirmation:"123456")
9.times {User.create(email: Faker::Internet.free_email, password: "123456", password_confirmation:"123456")}

(0..11).each do |i|
  user = User.all[i]
  5.times do
    recipe = user.recipes.create(title: Faker::Lorem.word, content: Faker::Hipster.paragraph(10, true, 4))
    (rand(8)+1).times do
      recipe.ingredients.create(name: Faker::Food.ingredient, quantity: Faker::Food.measurement)
    end
  end
end
