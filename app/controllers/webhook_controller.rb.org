require 'line/bot'

module Line
  module Bot
    class HTTPClient
      def http(uri)
        proxy = URI(ENV["FIXIE_URL"])
        http = Net::HTTP.new(uri.host, uri.port, proxy.host, proxy.port, proxy.user, proxy.password)
        if uri.scheme == "https"
          http.use_ssl = true
        end

        http
      end
    end
  end
end

class WebhookController < ApplicationController

  protect_from_forgery with: :null_session # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read
    #p body1
    #body = request.env["rack.input"].gets
    #p body
    #body = JSON.parse(URI.decode(body1).match(/\A"(.+)"\Z/)[1].gsub(/\\/, ''))

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    # this statement maybe mistake.
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        p event
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            #type: 'text',
            #text: event.message['text']
            type: 'image',
            originalContentUrl: "https://farm6.staticflickr.com/5444/31150114686_f195c9cea9_o.jpg",
            previewImageUrl: "https://farm6.staticflickr.com/5444/31150114686_f195c9cea9_o.jpg"
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          message = {
            type: 'image', 
            originalCotentUrl: msg.message_image_url,
            previewImageUrl: msg.message_image_thumbnail_url
          }
          client.get_message_content(event.message['id'])
          #tf = Tempfile.open("content")
          #tf.write(response.body)
          #client.reply_message(event['replyToken'], message)
        end
      end
    end
    

    render status: 200, json: { message: 'OK' }
  end
end
