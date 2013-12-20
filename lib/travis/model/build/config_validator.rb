class Build < Travis::Model
  class GenericValidator
    class Entry < Struct.new(:name, :options)

      def self.entries
        @entries ||= {}
      end
    end

    def self.entry(name, options, &block)
      p [:entry, name, options]
      entry = Entry.new(name, options)
      _entries = @current_entry ? @current_entry.entries : entries
      entries[name] = entry

      if block
        @current_entry = entry.entries
        instance_eval(&block)
        @current_entry = nil
      end
    end

    def self.values(type, options)
      p [:values, type, options]
    end

    def self.entries
      @entries ||= {}
    end

    delegate :entries, to: 'self.class.entries'
    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def valid?
      entries.all? do |entry|
        true
      end
    end
  end

  class ConfigValidator < GenericValidator
    entry :language, type: :string

    entry :env, type: [:string, :array, :hash] do
      entry :global, type: [:string, :array]
      entry :matrix, type: [:string, :array]

      values :string, for: :array
    end
  end
end
