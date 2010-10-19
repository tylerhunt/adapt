module Adapt
  module Common
    class ResponseEnvelope < Base
      property :ack
      property :build
      property :correlation_id
      property :timestamp
    end
  end
end
