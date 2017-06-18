require "facebook/messenger"
include Facebook::Messenger
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["FB_ACCESS_TOKEN"])

# message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
# message.sender      # => { 'id' => '1008372609250235' }
# message.sent_at     # => 2016-04-22 21:30:36 +0200
# message.text        # => 'Hello, bot!'
Bot.on :message do |message|
  if message.text.include?("hi")
    response = "hello, there"
  else
    response = " Two-fisted BOB the Destroyer parrots: " + message.text
  end
  Bot.deliver({

    recipient: message.sender,
    message: {
      text: response
    }
  }, access_token: ENV["FB_ACCESS_TOKEN"])
end
