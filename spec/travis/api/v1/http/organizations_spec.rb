require 'spec_helper'

describe Travis::Api::V1::Http::Organizations do
  include Support::Stubs, Support::Formats

  let(:data) { Travis::Api::Json::Http::Organizations.new([organization]).data }

  it 'data' do
    data.first.should == {
      'id' => organization.id,
      'name' => organization.name,
      'login' => organization.login,
    }
  end
end
