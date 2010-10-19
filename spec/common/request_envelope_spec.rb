require 'spec_helper'

describe Adapt::Common::ResponseEnvelope do
  it { should have_property(:ack) }
  it { should have_property(:build) }
  it { should have_property(:correlation_id) }
  it { should have_property(:timestamp) }
end
