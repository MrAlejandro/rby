module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances
      @instances || 0
    end

    private

    def register_instance
      @instances = self.instances + 1
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.send :register_instance
    end
  end
end
