# frozen_string_literal: true

module ActionHandler
  CONFIG_VAR_NAME = :@_action_handler_config

  class Config
    def self.get(handler_class)
      handler_class.instance_variable_get(CONFIG_VAR_NAME)
    end

    def self.set(handler_class, config)
      raise ArgumentError, 'invalid config' unless config.is_a?(self)

      handler_class.instance_variable_set(CONFIG_VAR_NAME, config)
    end

    attr_reader :as_controller
    attr_reader :action_methods
    attr_reader :args_suppliers
    attr_reader :custom_args

    def initialize
      @as_controller = nil
      @action_methods = nil
      @args_suppliers = []
      @custom_args = {} # { method_name: proc }
    end

    def as_controller=(block)
      raise ArgumentError, 'must be proc' unless block.is_a?(Proc)

      @as_controller = block
    end

    def action_methods=(names)
      raise ArgumentError, 'must be array' unless names.is_a?(Array)

      @action_methods = names
    end

    def add_args_supplier(supplier)
      @args_suppliers.push(supplier)
    end

    def add_arg(name, &block)
      @custom_args[name] = block
    end
  end
end
