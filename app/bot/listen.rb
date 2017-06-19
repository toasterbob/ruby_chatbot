require "facebook/messenger"
require 'open-uri'
require 'json'
include Facebook::Messenger

def get_advice
  r = open('http://api.adviceslip.com/advice')

  if r.status[0] == "200"
    doc = ""

    r.each do |line|
      doc << line
    end

    doc = JSON.parse(doc, :symbolize_names => true)
    advice = doc[:slip][:advice]

    return advice
  end

end

def get_quote
  r = open('http://www.yerkee.com/api/fortune')

  if r.status[0] == "200"
    doc = ""

    r.each do |line|
      doc << line
    end

    doc = JSON.parse(doc, :symbolize_names => true)
    quote = doc[:fortune]

    return quote
  end
end

def chuck_norris

  r = open('http://api.icndb.com/jokes/random')

  if r.status[0] == "200"
    doc = ""

    r.each do |line|
      doc << line
    end

    doc = JSON.parse(doc, :symbolize_names => true)
    response = doc[:value][:joke]

    return response
  end
end

def cat_names
  names = []
  @cats = Cat.all
  @cats.each do |cat|
    names << cat.name
  end
  names.join(", ")
end

def add_cat(text)
  arr = text.split("|")
  arr.shift
  params = {}
  arr.each do |a|
    a.strip!
    name, value = a.split(":")
    name.strip!
    value.strip!
    params[name] = value
  end

  new_cat = Cat.new(params)

  if params["name"] && params["address"]
    new_cat.save
    "Added #{new_cat.name}!"
  else
    "Improper format. Correct Sample: 'add_cat | name:bob | address:1404 Maple Dr.'"
  end
end

def check_user(id)
  if User.find_by(name: id).nil?
    User.create({name: id})
  end

end

def list_todos(id)
  current_user = User.find_by(name: id)
  todos = current_user.todos.where(completed: false)
  unfinished = todos.each_with_index.map { |item, i| "##{i + 1}. #{item.task} \n"}
  message = "You currently have #{todos.count} to-do item#{unfinished.count == 1 ? "" : "s"}: \n#{unfinished.join("")}"
end

def list_done(id)
  current_user = User.find_by(name: id)
  todos = current_user.todos.where(completed: true)
  done = todos.each_with_index.map { |item, i| "##{i + 1}. #{item.task} \n"}
  message = "You have #{done.count} item#{done.count == 1 ? "" : "s"} marked as done: \n#{done.join("")}"
end

def mark_done(id, num)
  current_user = User.find_by(name: id)
  todos = current_user.todos.where(completed: false)
  todo = todos[num - 1] if num > 0

  if todo
    todo.update({completed: true})
    message = "To-do item ##{num} ('#{todo.task}') marked as done"
  else
    message = "Invalid number"
  end
  
end

def add_item(id, item)
  current_user = User.find_by(name: id)
  Todo.create({task: item, completed: false, user_id: current_user.id})
  message = "To-do item '#{item}' added to list"
end

magic_eight = ["It is certain", "It is decidedly so", "Without a doubt",
              "Yes definitely", "You may rely on it", "As I see it, yes",
              "Most likely", "Magic eight this, monkey!", "Outlook good",
              "Yes", "Signs point to yes", "Reply hazy try again",
              "Ask again later", "Better not tell you now", "Cannot predict now",
              "Concentrate and ask again", "Don't count on it", "My reply is no",
              "My sources say no", "Outlook not so good", "Very doubtful",
              "If you have to ask the magic eight ball, you should rethink your life choices"]

lyrics = "Never gonna give you up, never gonna let you down
Never gonna run around and desert you.
Never gonna make you cry, never gonna say goodbye
Never gonna tell a lie and hurt you."

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["FB_ACCESS_TOKEN"])

# message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
# message.sender      # => { 'id' => '1008372609250235' }
# message.sent_at     # => 2016-04-22 21:30:36 +0200
# message.text        # => 'Hello, bot!'
Bot.on :message do |message|
  body = message.text.downcase
  id = message.sender["id"]
  check_user(id) #creates a new user in users table if none exists

  if body.include?("hello")
    response = "Hello there!"
  elsif body[0..2] === "add"
    item = body.slice(4, body.length)
    response = add_item(id, item)
  elsif body[0] === "#" && body.include?("done")
    response = mark_done(id, body[1].to_i)
  elsif body.include?("list") && body.include?("done")
    response = list_done(id)
  elsif body.include?("list")
    response = list_todos(id)
  elsif body.include?("cat") && body.include?("names")
    response = cat_names
  elsif body.include?("add_cat")
    response = add_cat(body)
  elsif body.include?("bye")
    response = "Goodbye"
  elsif body.include?("who") && (body.include?("this") || body.include?("are you"))
    response =  "I'll never tell"
  elsif body.include?("magic") && body.include?("ball") && (body.include?("eight") || body.include?("8"))
    response =  magic_eight[rand(magic_eight.length)]
  elsif body.include?("dice")
      response = "I rolled a #{rand(6) + 1} and a #{rand(6) + 1}."
  elsif body.include?("advice")
      response = get_advice
  elsif body.include?("rick") || body.include?("astley")
      response = lyrics
  elsif body.include?("quote")
      response = get_quote
  elsif body.include?("star wars") || body.include?("luke")
      response = "Luke, I am your father!"
  elsif body.include?("chuck norris")
      response = chuck_norris
  else
    response = "Boaty Bob McBoatFace repeats: " + message.text
  end
  Bot.deliver({

    recipient: message.sender,
    message: {
      text: response
    }
  }, access_token: ENV["FB_ACCESS_TOKEN"])
end
