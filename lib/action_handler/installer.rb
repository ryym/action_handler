# frozen_string_literal: true

require 'action_handler/args_maker'
require 'action_handler/default_args'
require 'action_handler/response_evaluator'

module ActionHandler
  class Installer
    attr_reader :args_maker
    attr_reader :args_supplier

    def initialize(
      args_maker: ActionHandler::ArgsMaker.new,
      args_supplier: ActionHandler::DefaultArgs.new
    )
      @args_maker = args_maker
      @args_supplier = args_supplier
    end

    def install(handler, ctrl_class)
      actions = own_public_methods(handler)
      actions.each do |name|
        installer = self
        ctrl_class.send(:define_method, name) do
          method = handler.method(name)
          args = installer.args_maker.make_args(
            method.parameters,
            installer.args_supplier,
            context: self,
          )
          handler.method(name).call(*args)
        end
      end
    end

    # List all public methods except super class methods.
    private def own_public_methods(obj)
      methods = obj.public_methods
      obj.class.ancestors.drop(1).inject(methods) do |ms, sp|
        ms - sp.instance_methods
      end
    end
  end
end
