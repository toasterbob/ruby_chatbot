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
  if body.include?("hi") || body.include?("hello")
    response = "Why hello there"
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
