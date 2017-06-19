require "facebook/messenger"
include Facebook::Messenger

magic_eight = ["It is certain", "It is decidedly so", "Without a doubt",
              "Yes definitely", "You may rely on it", "As I see it, yes",
              "Most likely", "Magic eight this, monkey!", "Outlook good",
              "Yes", "Signs point to yes", "Reply hazy try again",
              "Ask again later", "Better not tell you now", "Cannot predict now",
              "Concentrate and ask again", "Don't count on it", "My reply is no",
              "My sources say no", "Outlook not so good", "Very doubtful",
              "If you have to ask the magic eight ball, you should rethink your life choices"]

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
      r.message "Goodbye"
  elsif body.include?("who") && (body.include?("this") || body.include?("are you"))
    r.message "I'll never tell"
  elsif body.include?("magic") && body.include?("ball") && (body.include?("eight") || body.include?("8"))
    r.message magic_eight[rand(magic_eight.length)]
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
