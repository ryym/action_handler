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

    attr_reader :action_methods

    def initialize
      @action_methods = nil
    end

    def action_methods=(names)
      raise ArgumentError, 'must be array' unless names.is_a?(Array)

      @action_methods = names
    end
  end
end
