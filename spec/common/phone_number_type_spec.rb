require 'spec_helper'

describe Adapt::Common::PhoneNumberType do
  it { should have_property(:country_code) }
  it { should have_property(:extension) }
  it { should have_property(:phone_number) }

  it { should validate_presence_of(:country_code) }
  it { should validate_presence_of(:phone_number) }
end
