require 'yaml'
require 'json'
require 'openssl'

module Travis
  class Config < Hashr
    class Files
      def load
        filenames.inject({}) do |conf, filename|
          conf.deep_merge(File.new(filename).load)
        end
      end

      private

        def filenames
          @filenames ||= Dir['config/{travis.yml,travis/*.yml}'].sort
        end
    end
  end
end
