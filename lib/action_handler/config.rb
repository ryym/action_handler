# frozen_string_literal: true

module ActionHandler
  CONFIG_VAR_NAME = :@_action_handler_config

  Config = Struct.new(:action_methods) do
    def self.get(handler_class)
      handler_class.instance_variable_get(CONFIG_VAR_NAME)
    end

    def self.set(handler_class, config)
      raise ArgumentError, 'invalid config' unless config.is_a?(self)

      handler_class.instance_variable_set(CONFIG_VAR_NAME, config)
    end
  end
end
