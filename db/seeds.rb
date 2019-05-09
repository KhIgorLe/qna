# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Subscription.delete_all
Answer.delete_all
Question.delete_all
User.delete_all

User.create(email: 'admin@example.com', password: 'qwerty', password_confirmation: 'qwerty', admin: true)

users_params = [
  { email: 'user1@example.com', password: 'qwerty', password_confirmation: 'qwerty' },
  { email: 'user2@example.com', password: 'qwerty', password_confirmation: 'qwerty' },
]

users = User.create(users_params)

questions_params = [
  { title: 'question1', body: '2 + 2 = ?',  user: users[0] },
  { title: 'question2', body: '4 - 5  = ?', user: users[0] },
  { title: 'question3', body: '4 + 5  = ?', user: users[1] },
  { title: 'question4', body: '2 * 3  = ?', user: users[1] },
  { title: 'question5', body: '3 * 3  = ?', user: users[2] },
  { title: 'question6', body: '6 / 2  = ?', user: users[2] },
]

questions = Question.create(questions_params)

answers_params = [
  { body: '2',  user: users[2], question: questions[5] },
  { body: '3', user: users[2], question: questions[4] },
  { body: '4', user: users[1], question: questions[3] },
  { body: '5', user: users[1], question: questions[2] },
  { body: '6', user: users[0], question: questions[1] },
  { body: '7', user: users[0], question: questions[0] },
]

Answer.create(answers_params)
