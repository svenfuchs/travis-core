begin
  require 'librato/metrics'
rescue LoadError
  "Couldn't find Librato gem, ignoring."
end

module Travis
  module Addons
    module LibratoStatistics
      class Task < Travis::Task
        def process
          [repository_key, owner_key, language_key].each do |metric|
            queue.add "travis.build.statistics.#{metric}.#{build_result}.count" => {
              value: 1,
              source: Travis.config.host,
              type: :gauge
            }
          end
          queue.submit
        end

        def build_result
          build[:state]
        end

        def queue
          Librato::Metrics::Queue.new(client: client)
        end

        def client
          @client ||= Librato::Metrics::Client.new(Travis.config.librato)
        end

        def repository_key
          repository[:id]
        end

        def owner_key
          repository[:slug].split('/', 0)
        end

        def language_key
          build[:config][:language] || 'default'
        end
      end
    end
  end
end
