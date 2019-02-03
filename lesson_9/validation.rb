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
        var_value = instance_variable_get("@#{var_name}")
        case validation_type
        when :presence
          validate_presence(var_name, var_value)
        when :format
          validate_format(var_name, var_value, extra)
        when :type
          validate_type(var_name, var_value, extra)
        else
          raise "Unknown validation '#{validation_type}'"
        end
      end

      validate if respond_to?(:validate)
    end

    protected

    def validators
      puts self.class
      self.class.send :validators || []
    end

    private

    def validate_presence(name, value)
      raise "Attribute presence check failed on "\
            "'@#{name}' with value '#{value}'." if value.nil? || value.empty?
    end

    def validate_format(name, value, pattern)
      raise "RegEx pattern expected as second parameter." unless pattern.is_a?(Regexp)

      matches_pattern = value =~ pattern
      raise "The attribute '#{name}' does not match the pattern '#{pattern}'" unless matches_pattern
    end

    def validate_type(name, value, type)
      raise "Object class expected as second parameter." unless type.is_a?(Class)

      raise "The attribute '#{name}' has a wrong type, "\
            "got: '#{value.class}', expected '#{type}'" unless value.is_a?(type)
    end
  end
end
