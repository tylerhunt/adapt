module Adapt
  module Common
    class ErrorData < Base
      SEVERITIES = %w(Error Warning).freeze

      property :category
      property :domain
      property :error_id
      property :exception_id
      property :message
      property :parameter
      property :severity, :inclusion => { :in => SEVERITIES }
      property :subdomain
    end
  end
end
