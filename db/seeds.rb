# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

peter = User.create(email: "peter@123.com", password: "123456", password_confirmation:"123456")
mary = User.create(email: "mary@123.com", password: "123456", password_confirmation:"123456")
david = User.create(email: "david@123.com", password: "123456", password_confirmation:"123456")

post1 = peter.posts.create(title: "first post")
post2 = peter.posts.create(title: "second post")

post1.categories.create(name: "science")
post1.categories.create(name: "fiction")

post2.categories.create(name: "science")
post2.categories.create(name: "history")

mary.commented_posts << post1

peter.commented_posts << post2

comment1 = david.comments.create(post: post2)
reply1 = comment1.replies.create(replier: mary)
reply2 = comment1.replies.create(replier: peter)
reply11 = reply1.replies.create(replier: david)
reply12 = reply1.replies.create(replier: david)
reply111 = reply11.replies.create(replier: mary)
reply112 = reply11.replies.create(replier: peter)
