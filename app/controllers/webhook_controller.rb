require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery with: :null_session # CSRF対策無効化

def client
  @client ||= Line::Bot::Client.new { |config|
    #config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    #config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    config.channel_secret = "957226d38fb37308c0f5867fddecd954"
    config.channel_token = "1Py/SlVGW7cLzr9sZvJeyi3Hrc/8vIxX9cKXqTuA9LmwdFB9wgy4ZluMZ43taYNcUugO+VUcGCygb2MJ53MmiIVh6MW2b1RqFymhA9v7Dn+njyfJWRg344i9v1ceWMQ3Z6fv+4JB6dprS9H2mL2sUwdB04t89/1O/w1cDnyilFU="
  }
end

def callback
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
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
        response = client.reply_message(event['replyToken'], message)
        p response
        puts "ecbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
      puts "FeecbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"
    end
  }
    puts "df;alsjKJGFeecbAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"

  #"OK"
  render status: 200, json: { message: 'OK' }
end
end
