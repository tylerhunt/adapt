require 'spec_helper'

describe Adapt::Common::FaultMessage do
  it { should have_property(:error) }
  it { should have_property(:response_envelope) }
end
