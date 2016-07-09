# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#12 users
peter = User.create(email: "peter@123.com", password: "123456", password_confirmation:"123456")
mary = User.create(email: "mary@123.com", password: "123456", password_confirmation:"123456")
david = User.create(email: "david@123.com", password: "123456", password_confirmation:"123456")
9.times {User.create(email: Faker::Internet.free_email, password: "123456", password_confirmation:"123456")}

#12 posts
post1 = peter.posts.create(title: "first post")
post2 = peter.posts.create(title: "second post")
10.times do
  User.all[Random.rand(12)].posts.create(title: Faker::Hipster.sentence)
end

#? categories
post1.categories.create(name: "science")
post1.categories.create(name: "fiction")
post2.categories.create(name: "horror")
post2.categories.create(name: "history")
12.times do
  Post.all[Random.rand(12)].categories.find_or_create_by(name: Faker::Hipster.word)
end


30.times do
  User.all[Random.rand(12)].comments.create(post: Post.all[Random.rand(12)],content: Faker::Hipster.sentences(Random.rand(9)).join(" "))
end

40.times do
  reply = Comment.all[Random.rand(30)].replies.create(replier: User.all[Random.rand(12)], content: Faker::Hipster.sentences(Random.rand(4)).join(" ") )
  reply.post = reply.repliable.post
  reply.save
end

100.times do
  reply = Reply.all[Random.rand(40)].replies.create(replier: User.all[Random.rand(12)], content: Faker::Hipster.sentences(1).join(" ") )
  reply.post = reply.repliable.post
  reply.save
end
