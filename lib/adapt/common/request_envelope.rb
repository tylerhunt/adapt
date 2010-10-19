module Adapt
  module Common
    class RequestEnvelope < Base
      property :detail_level, :default => 'ReturnAll', :presence => true
      property :error_language, :default => 'en_US', :presence => true
    end
  end
end
