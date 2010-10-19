require 'spec_helper'

describe Adapt::Common::RequestEnvelope do
  it { should have_property(:detail_level).with_default('ReturnAll') }
  it { should have_property(:error_language).with_default('en_US') }

  it { should validate_presence_of(:detail_level) }
  it { should validate_presence_of(:error_language) }
end
