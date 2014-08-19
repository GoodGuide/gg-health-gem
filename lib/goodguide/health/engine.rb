module Goodguide
  module Health
    class Engine < ::Rails::Engine
      isolate_namespace Goodguide::Health
    end
  end
end
