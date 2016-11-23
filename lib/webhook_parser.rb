module RspApp
  class ParamsParser < ActionDispatch::ParamsParser
    def initialize(app, opts = {})
      @app = app
      @opts = opts
      super
    end

    def call(env)
      if @opts[:ignore_prefix].nil? or !env['PATH_INFO'].start_with?(@opts[:ignore_prefix])
        p "AAAAAAAAAAAAAAA"
        super(env)
        p "BAAAAAAAAAAAAAA"
      else
        p "cAAAAAAAAAAAAAA"
        res = @app.call(env)
        p "dAAAAAAAAAAAAAA"
        p res
        res
      end
    end
  end
end
