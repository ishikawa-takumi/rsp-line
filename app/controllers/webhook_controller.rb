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
    body = request.env["rack.input"].gets

    message = {
      #type: 'text',
      #text: event.message['text']
      type: 'image',
      originalContentUrl: body,
      previewImageUrl: body
    }
    client.push_message("U5c1d32a3b59a0baae342473e1e996cf3", message)
    render status: 200, json: { message: 'OK' }
    #render :nothing => true
  end 
end
