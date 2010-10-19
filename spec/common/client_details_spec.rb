require 'spec_helper'

describe Adapt::Common::ClientDetails do
  it { should have_property(:application_id) }
  it { should have_property(:customer_id) }
  it { should have_property(:customer_type) }
  it { should have_property(:device_id) }
  it { should have_property(:geo_location) }
  it { should have_property(:ip_address) }
  it { should have_property(:model) }
  it { should have_property(:partner_name) }
end
