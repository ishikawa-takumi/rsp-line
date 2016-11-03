require 'line/bot'

class WebhookController < ApplicationController
  #protect_from_forgery with: :null_session # CSRF対策無効化

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def callback
  body = request.body.read

  print a
  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end
  print b

  events = client.parse_events_from(body)
  print c
  events.each { |event|
    print d
    case event
    when Line::Bot::Event::Message
      print e
      case event.type
      when Line::Bot::Event::MessageType::Text
        print g
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
        print h
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        print i
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
        print j
      end
    end
  }

  "OK"
end
end
