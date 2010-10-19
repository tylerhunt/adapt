require 'spec_helper'

describe Adapt::Common::ReceiverList do
  it { should have_property(:receiver) }

  it { should validate_presence_of(:receiver) }
end
