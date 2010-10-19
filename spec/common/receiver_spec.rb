require 'spec_helper'

describe Adapt::Common::Receiver do
  it { should have_property(:amount) }
  it { should have_property(:email) }
  it { should have_property(:invoice_id) }
  it { should have_property(:payment_type) }
  it { should have_property(:phone) }
  it { should have_property(:primary).with_default(false) }

  it { should validate_presence_of(:amount) }
  it { should validate_inclusion_of(:payment_type, :in => %w(GOODS SERVICE PERSONAL CASHADVANCE)) }
  it { should validate_inclusion_of(:primary, :in => [true, false]) }
end
