module Adapt
  module Methods
    # Sets payment options
    class SetPaymentOptions
      class Request < Base
        property :pay_key, :presence => true
        property :request_envelope, :type => Common::RequestEnvelope, :presence => true

        property :initiating_entity do
          property :institution_customer do
            property :country_code, :presence => true
            property :display_name, :presence => true
            property :email
            property :first_name, :presence => true
            property :institution_customer_id, :presence => true
            property :institution_id, :presence => true
            property :last_name, :presence => true
          end
        end

        property :display_options do
          property :email_header_image_url
          property :email_marketing_image_url
        end
      end

      class Response < Base
        property :response_envelope, :type => Common::ResponseEnvelope
        property :error, :type => [Common::ErrorData]
      end
    end
  end
end
