module Travis
  module Addons
    module Librato
      autoload :EventHandler, 'travis/addons/librato/event_handler'
      autoload :Task,         'travis/addons/librato/task'

      module Instruments
        autoload :EventHandler, 'travis/addons/librato/instruments'
        autoload :Task,         'travis/addons/librato/instruments'
      end
    end
  end
end
