module Travis
  module Addons
    module Librato
      class EventHandler < Event::Handler
        EVENTS = /build:finished/

        def handle?
          !pull_request? && targets.present? && config.send_on_finished_for?(:librato)
        end

        def handle
          Travis::Addons::Librato::Task.run(:librato, payload, targets: targets)
        end

        def targets
          @targets ||= config.notification_values(:librato, :annotations)
        end
      end
    end
  end
end
