module Goodguide
  class Health
    class NewlineMiddleware
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)

        unless body.last.end_with?("\n")
          body.push("\n")
        end

        [status, headers, body]
      end
    end
  end
end
