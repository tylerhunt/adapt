module Adapt
  module Common
    class ClientDetails < Base
      property :application_id, :presence => true
      property :customer_id, :presence => true
      property :customer_type, :presence => true
      property :device_id
      property :geo_location, :presence => true
      property :ip_address, :presence => true
      property :model, :presence => true
      property :partner_name, :presence => true
    end
  end
end
