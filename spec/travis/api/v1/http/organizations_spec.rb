require 'spec_helper'

describe Travis::Api::V1::Http::Organizations do
  include Travis::Testing::Stubs

  let(:data) { Travis::Api::V1::Http::Organizations.new([org]).data }

  it 'data' do
    data.first.should == {
      'id' => org.id,
      'name' => org.name,
      'login' => org.login,
    }
  end
end
