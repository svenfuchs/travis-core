require 'yaml'
require 'json'
require 'openssl'

module Travis
  class Config < Hashr
    class File
      class Signature
        def initialize(*)
        end

        def verify(*)
          true
        end
      end

      class << self
        attr_accessor :signature
      end
      self.signature = Signature

      attr_reader :filename

      def initialize(filename)
        @filename = filename
      end

      def load
        data = YAML.load_file(filename) || {} rescue {}
        verify(data, data.delete('signature'), filename) if data.has_key?('signature')
        data[Travis.env] || {}
      end

      private

        def verify(data, signature, filename)
          unless self.class.signature.new(signature).verify(data)
            raise "Config: could not verify the signature of #{filename}."
          end
        end
    end
  end
end
