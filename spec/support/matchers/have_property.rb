RSpec::Matchers.define :have_property do |property|
  match do |object|
    has_property(object, property) && has_default(object, property)
  end

  chain :with_default do |default|
    @default = default
  end

  description do
    "have property #{property.to_s.humanize.downcase}".tap do |description|
      description << " with default value #{@default.inspect}" if @default
    end
  end

  def has_property(object, property)
    object.properties.include?(property)
  end

  def has_default(object, property)
    @default ? object.send(property) == @default : true
  end
end
