require 'active_support/inflector'

module Adapt
  class Base
    include ActiveModel::Validations

    class_inheritable_array :properties
    self.properties ||= []

    def self.property(name, options={}, &block)
      unless default = options.delete(:default)
        attr_reader(name)
      else
        define_method(name) do
          unless instance_variable_defined?(:"@#{name}")
            send(:"#{name}=", default)
          end

          instance_variable_get(:"@#{name}")
        end
      end

      type = if block_given?
        const_set(
          name.to_s.classify,
          Class.new(Base).tap { |base| base.class_eval(&block) }
        )
      else
        options.delete(:type)
      end

      unless type
        attr_writer(name)
      else
        collection = options.delete(:collection) || type.is_a?(Array)
        type = type.first if type.is_a?(Array)

        define_method(:"#{name}=") do |value|
          value = unless collection
            type.new(value)
          else
            value.collect { |attributes| attributes.is_a?(Hash) ? type.new(attributes) : attributes }
          end

          instance_variable_set(:"@#{name}", value)
        end
      end

      validates(name, options) if options.any?
      properties << name unless properties.include?(name)
    end

    def initialize(attributes={})
      self.attributes = attributes
    end

    def attributes
      attributes = properties.each_with_object({}) do |name, attributes|
        value = send(name)
        attributes[name] = value unless value.nil?
      end

      encode_keys(attributes)
    end

    def attributes=(attributes)
      attributes.each do |key, value|
        send(:"#{decode_key(key)}=", value)
      end
    end

    def to_json
      ActiveSupport::JSON.encode(attributes)
    end

    def from_json(json)
      self.attributes = ActiveSupport::JSON.decode(json)
      self
    end

    def encode_keys(object)
      case object
        when Array then object.collect { |value| encode_keys(value) }
        when Hash then Hash[object.collect { |key, value| [encode_key(key), encode_keys(value)] }]
        when Base then encode_keys(object.attributes)
        else object
      end
    end
    private :encode_keys

    def encode_key(key)
      key.is_a?(Symbol) ? key.to_s.camelcase(:lower) : key
    end
    private :encode_key

    def decode_key(key)
      key.is_a?(Symbol) ? key : key.underscore.to_sym
    end
    private :decode_key
  end
end
