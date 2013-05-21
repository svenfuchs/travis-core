module Travis
  module Addons
    module LibratoStatistics
      autoload :EventHandler, 'travis/addons/librato_statistics/event_handler'
      autoload :Instruments, 'travis/addons/librato_statistics/instruments'
      autoload :Task, 'travis/addons/librato_statistics/task'
    end
  end
end
