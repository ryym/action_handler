# frozen_string_literal: true

require 'action_handler/args_maker'
require 'action_handler/response_evaluator'

# TODO: Add `controller_send` (to use controller methods like `send_data`)

# It is better if there is a way to return streaming response.
# (`self.response_body = ` or `response.stream.write`?)

module ActionHandler
  class Installer
    attr_reader :args_maker
    attr_reader :res_evaluator

    def initialize(
      args_maker: ActionHandler::ArgsMaker.new,
      res_evaluator: ActionHandler::ResponseEvaluator.new
    )
      @args_maker = args_maker
      @res_evaluator = res_evaluator
    end

    def install(ctrl_class, &block)
      ctrl_class.instance_variable_set(:@_action_handler_factory, block)

      installer = self
      initializer = Module.new.tap do |m|
        m.define_method(:initialize) do |*args|
          super(*args)
          factory = self.class.instance_variable_get(:@_action_handler_factory)
          handler = factory.call(self)
          installer.send(:setup, self, handler)
        end
      end

      ctrl_class.prepend initializer
    end

    private def setup(ctrl, handler)
      config = ActionHandler::Config.get(handler.class) || ActionHandler::Config.new

      actions = action_methods(handler, config)
      args_supplier = args_supplier(config)

      actions.each do |name|
        installer = self

        # If we use `define_singleton_method`, methods don't work correctly.
        # I don't know Rails internal details but
        # Rails requires methods to be defined in a class.
        ctrl.class.define_method(name) do
          method = handler.method(name)
          args = installer.args_maker.make_args(method, args_supplier, context: self)
          res = method.call(*args)
          installer.res_evaluator.evaluate(self, res)
        end
      end
    end

    private def action_methods(handler, config)
      config.action_methods || own_public_methods(handler)
    end

    private def args_supplier(config)
      args_hash = {}

      config.args_suppliers.each do |supplier|
        own_public_methods(supplier).each do |name|
          args_hash[name] = supplier.method(name)
        end
      end

      args_hash = args_hash.merge(config.custom_args)
      ActionHandler::Args.from_hash(args_hash)
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
