module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}"
        var_history_name = "@#{name}_history"

        define_method(name) do
          instance_variable_get(var_name)
        end

        define_method("#{name}_history") do
          instance_variable_get(var_history_name)
        end

        define_method("#{name}=") do |value|
          history = instance_variable_get(var_history_name) || []
          instance_variable_set(var_history_name, history << value)

          instance_variable_set("@#{name}", value)
        end
      end
    end

    def strong_attr_accessor(name, klass)
      define_method(name) do
        instance_variable_get("@#{name}")
      end

      define_method("#{name}=") do |value|
        raise "Invalid type of argument passed." unless value.is_a?(klass)

        instance_variable_set("@#{name}", value)
      end
    end
  end
end
