require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery with: :null_session # CSRF対策無効化

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def callback
  puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"
  body = request.body.read
  puts "aAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end
  puts "bAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"

  events = client.parse_events_from(body)
  puts "cbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"
  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        puts "iecbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"
        client.reply_message(event['replyToken'], message)
        puts "ecbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        puts "eecbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
      puts "FeecbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"
    end
    puts "KJGFeecbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"
  }
    puts "df;alsjKJGFeecbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"

  "OK"
end
end
