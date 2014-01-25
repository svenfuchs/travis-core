require 'spec_helper'

describe Travis::Mailer::Optout do
  include Support::Redis

  describe '.opted_out?' do
    context 'when the email is opted out' do
      before do
        Travis::Mailer::Optout.opt_out('doe@example.com')
      end

      it 'returns true with the same email' do
        Travis::Mailer::Optout.opted_out?('doe@example.com').should be_true
      end

      it 'returns true with the uppercased email' do
        Travis::Mailer::Optout.opted_out?('DOE@EXAMPLE.COM').should be_true
      end
    end

    context 'when the email is not opted out' do
      it 'returns false' do
        Travis::Mailer::Optout.opted_out?('doe@example.com').should be_false
      end
    end
  end
end
