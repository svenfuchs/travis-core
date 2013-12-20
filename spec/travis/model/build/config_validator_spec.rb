require 'spec_helper'

describe Build::GenericValidator do
  attr_reader :validator_class

  context 'with a nested hash, string or array' do
    before do
      @validator_class = Class.new(Build::GenericValidator) do
        entry :env, type: [:string, :array, :hash] do
          entry :global, type: [:string, :array] do
            values for: :array, only: [:string, :hash]
          end
          entry :matrix, type: [:string, :array] do
            values for: :array, only: [:string, :hash]
          end

          values for: :array, only: [:string]
        end
      end

    end

    it 'allows env to be a string' do
      validator_class.new('env' => 'FOO=bar').should be_valid
    end

    it 'allows env to be a hash' do
      validator_class.new('env' => {}).should be_valid
    end

    it 'allows env to be an array of strings' do
      validator_class.new('env' => ['FOO=bar']).should be_valid
    end
  end
end
