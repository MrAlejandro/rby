module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(var_name, validation_type, extra = nil)
      validators = instance_variable_get("@validators") || []
      validators << [var_name, validation_type, extra]
      instance_variable_set("@validators", validators)
    end

    protected

    attr_reader :validators
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    def validate!
      validators.each do |var_name, validation_type, extra|
        validator_method = "validate_#{validation_type}".to_sym
        raise "Unknown validation '#{validation_type}'" unless respond_to?(validator_method, true)

        var_value = instance_variable_get("@#{var_name}")
        self.send validator_method, var_name.to_s, var_value, extra
        validate if respond_to?(:validate)
      end
    end

    protected

    def validators
      self.class.send :validators || []
    end

    private

    def validate_presence(name, value, extra)
      if value.nil? || value.to_s.empty?
        raise "Attribute presence check failed on '@#{name}' with value '#{value}'."
      end
    end

    def validate_format(name, value, pattern)
      raise "RegEx pattern expected as second parameter." unless pattern.is_a?(Regexp)

      unless value =~ pattern
        raise "The attribute '#{name}' does not match the pattern '#{pattern}'"
      end
    end

    def validate_type(name, value, type)
      raise "Object class expected as second parameter." unless type.is_a?(Class)

      unless value.is_a?(type)
        raise "The attribute '#{name}' has a wrong type, got: '#{value.class}', expected '#{type}'"
      end
    end
  end
end
