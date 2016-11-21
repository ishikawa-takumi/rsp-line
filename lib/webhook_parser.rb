module RspApp
  class ParamsParser < ActionDispatch::ParamsParser
    def initialize(app, opts = {})
      @app = app
      @opts = opts
      p "AAAAAAAAAAAA"
      super
    end

    def call(env)
      p "BBBBBBBBBBBBBb"
      if @opts[:ignore_prefix].nil? or !env['PATH_INFO'].start_with?(@opts[:ignore_prefix])
        p @opts[:ignore_prefix]
        p env['PATH_INFO']
        super(env)
      else
        p "cccccccccccc"
        @app.call(env)
      end
    end
  end
end
