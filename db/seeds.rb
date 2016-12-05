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
Rating.delete_all



#12 users, 5 recipes each, each recipes has

peter = User.create(email: "peter@123.com", password: "123456", password_confirmation:"123456")
mary = User.create(email: "mary@123.com", password: "123456", password_confirmation:"123456")
david = User.create(email: "david@123.com", password: "123456", password_confirmation:"123456")
9.times {User.create(email: Faker::Internet.free_email, password: "123456", password_confirmation:"123456")}

(0..11).each do |i|
  user = User.all[i]
  5.times do
    recipe = user.recipes.find_or_create_by(title: Faker::Lorem.word)
    recipe.content = Faker::Hipster.paragraph(10, true, 4)
    recipe.save
    (rand(8)+1).times do
      i = recipe.ingredients.find_or_create_by(name: Faker::Food.ingredient)
      i.quantity = Faker::Food.measurement
      i.save
      binding.pry unless i.persisted?
    end
  end
end
#=begin
30.times do
  User.all[rand(12)].comments.create(recipe: Recipe.all[Random.rand(12)],content: Faker::Hipster.sentences(Random.rand(9)+1).join(" "))
end

40.times do
  reply = Comment.all[Random.rand(30)].replies.create(replier: User.all[Random.rand(12)], content: Faker::Hipster.sentences(Random.rand(4)+1).join(" ") )
  reply.recipe = reply.repliable.recipe
  reply.save
end

100.times do
  reply = Reply.all[Random.rand(40)].replies.create(replier: User.all[Random.rand(12)], content: Faker::Hipster.sentences(1).join(" ") )
  reply.recipe = reply.repliable.recipe
  reply.save
end

#=begin
30.times do
  User.all[rand(12)].comments.create(recipe: Recipe.all[Random.rand(12)],content: Faker::Hipster.sentences(Random.rand(9)+1).join(" "))
end

40.times do
  reply = Comment.all[Random.rand(30)].replies.create(replier: User.all[Random.rand(12)], content: Faker::Hipster.sentences(Random.rand(4)+1).join(" ") )
  reply.recipe = reply.repliable.recipe
  reply.save
end

100.times do
  reply = Reply.all[Random.rand(40)].replies.create(replier: User.all[Random.rand(12)], content: Faker::Hipster.sentences(1).join(" ") )
  reply.recipe = reply.repliable.recipe
  reply.save
end

User.all.each do |user|
  10.times do
    rating = user.ratings.find_or_initialize_by(recipe: Recipe.all[rand(60)])
    rating.grade = rand(10)+1
    rating.save
  end
end
#=end
