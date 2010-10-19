require 'spec_helper'

describe Adapt::Common::ErrorData do
  it { should have_property(:category) }
  it { should have_property(:domain) }
  it { should have_property(:error_id) }
  it { should have_property(:exception_id) }
  it { should have_property(:message) }
  it { should have_property(:parameter) }
  it { should have_property(:severity) }
  it { should have_property(:subdomain) }

  it { should validate_inclusion_of(:severity, :in => %w(Error Warning)) }
end
