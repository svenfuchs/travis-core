require 'spec_helper'

describe Event do
  include Support::ActiveRecord

  let!(:events) { [create(:event), create(:event), create(:event)] }

  describe 'recent' do
    it 'orders events descending by id' do
      Event.recent.map(&:id).should == events.map(&:id).reverse
    end
  end
end

