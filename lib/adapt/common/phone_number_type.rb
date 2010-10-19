module Adapt
  module Common
    class PhoneNumberType < Base
      property :country_code, :presence => true
      property :extension
      property :phone_number, :presence => true
    end
  end
end
