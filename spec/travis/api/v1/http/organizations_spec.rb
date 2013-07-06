require 'spec_helper'

describe Travis::Api::V1::Http::Organizations do
  include Travis::Testing::Stubs

  let(:data) { Travis::Api::V1::Http::Organizations.new([organization]).data }

  it 'data' do
    data.first.should == {
      'id' => organization.id,
      'name' => organization.name,
      'login' => organization.login,
    }
  end
end
