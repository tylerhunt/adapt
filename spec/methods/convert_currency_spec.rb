require 'spec_helper'

describe Adapt::Methods::ConvertCurrency do
  it_should_behave_like "a method"

  context "on success" do
    let(:request_attributes) do
      {
        :base_amount_list => [
          { :currency => { :amount => 100, :code => 'USD' } },
          { :currency => { :amount => 100, :code => 'GBP' } }
        ],
        :convert_to_currency_list => [
          { :currency_code => 'EUR' }
        ],
        :request_envelope => {
          :detail_level => 'ReturnAll',
          :error_language => 'en_US'
        }
      }
    end

    let(:response_fixture) { 'convert_currency_success' }

    context "response envelope" do
      subject { response.response_envelope }

      its(:timestamp) { should == '2010-07-27T21:01:32.347-07:00' }
      its(:ack) { should == 'Success' }
      its(:correlation_id) { should == '693bb9196bf03' }
      its(:build) { should == '1383772' }
    end

    context "estimated amount table" do
      let(:estimated_amount_table) { response.estimated_amount_table }

      context "currency conversion list" do
        let(:currency_conversion_list) { estimated_amount_table.currency_conversion_list.first }

        context "base amount" do
          let(:base_amount) { currency_conversion_list.base_amount }

          subject { base_amount }

          its(:amount) { should == '100.0' }
          its(:code) { should == 'GBP' }
        end

        context "currency list" do
          let(:currency_list) { currency_conversion_list.currency_list.currency.first }

          subject { currency_list }

          its(:amount) { should == '142.86' }
          its(:code) { should == 'EUR' }
        end
      end
    end

    context "error" do
      it("is nil") { response.error.should be_nil }
    end
  end

  context "on failure" do
    let(:request_attributes) do
      {
        :base_amount_list => [
          { :currency => { :amount => 100, :code => 'USD' } },
          { :currency => { :amount => 100, :code => 'GBP' } }
        ],
        :convert_to_currency_list => [
          { :currency_code => 'EUR' }
        ]
      }
    end

    let(:response_fixture) { 'convert_currency_failure' }

    context "response envelope" do
      subject { response.response_envelope }

      its(:timestamp) { should == '2010-08-03T18:33:18.767-07:00' }
      its(:ack) { should == 'Failure' }
      its(:correlation_id) { should == 'b4abecc0bc1cf' }
      its(:build) { should == '1383772' }
    end

    context "estimated amount table" do
      it("is nil") { response.estimated_amount_table.should be_nil }
    end

    context "error" do
      subject { response.error.first }

      its(:error_id) { should == '500000' }
      its(:domain) { should == 'PLATFORM' }
      its(:severity) { should == 'Error' }
      its(:category) { should == 'Application' }
      its(:message) { should == 'Internal Error' }
    end
  end
end
