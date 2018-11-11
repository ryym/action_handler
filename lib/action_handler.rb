# frozen_string_literal: true

require 'action_handler/config'
require 'action_handler/args'
require 'action_handler/controller'
require 'action_handler/equip'

module ActionHandler
  # Enable to autoload handlers defined in a controller file.
  # Rails autoloading works only if the constant is defined in
  # a file matching its name. So if `FooHandler` is defined in
  # `foo_controller.rb`, it cannot be autoloaded.
  # (https://guides.rubyonrails.org/autoloading_and_reloading_constants.html)
  #
  # So this hooks const_missing and load the corresponding controller.
  # If the controller exists, its handler will be loaded as well.
  #
  # Currently this supports only the handlers defined in the top level scope.
  module_function def autoload_handlers_from_controller_file
    unless defined? Rails
      raise 'Rails is not defined. This method is supposed to use in Rails environment.'
    end

    return if @hook_registered

    @hook_registered = true

    # Perhaps this warning is a RuboCop's bug.
    # rubocop:disable Lint/NestedMethodDefinition
    def Object.const_missing(name)
      # rubocop:enable Lint/NestedMethodDefinition

      return super unless name =~ /\A[a-zA-Z0-9_]+Handler\z/
      return super if name == :ActionHandler

      # Try to autoload the corresponding controller.
      prefix = name.to_s.sub(/Handler\z/, '')
      begin
        const_get("::#{prefix}Controller")
      rescue NameError
        super
      end

      # Return the handler if loaded.
      return const_get(name) if Object.const_defined?(name)

      # Otherwise raise the NameError.
      super
    end
  end
end
