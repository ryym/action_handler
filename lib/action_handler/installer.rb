# frozen_string_literal: true

require 'action_handler/args_maker'
require 'action_handler/args/default'
require 'action_handler/response_evaluator'

module ActionHandler
  class Installer
    attr_reader :args_maker
    attr_reader :res_evaluator

    def initialize(
      args_maker: ActionHandler::ArgsMaker.new,
      args_supplier: ActionHandler::Args::Default.new,
      res_evaluator: ActionHandler::ResponseEvaluator.new
    )
      @args_maker = args_maker
      @default_args_supplier = args_supplier
      @res_evaluator = res_evaluator
    end

    def install(handler, ctrl_class)
      config = ActionHandler::Config.get(handler.class) || ActionHandler::Config.new

      actions = action_methods(handler, config)
      args_supplier = args_supplier(config)
      actions.each do |name|
        installer = self
        ctrl_class.send(:define_method, name) do
          method = handler.method(name)
          args = installer.args_maker.make_args(
            method.parameters,
            args_supplier,
            context: self,
          )
          res = method.call(*args)
          installer.res_evaluator.evaluate(self, res)
        end
      end
    end

    private def action_methods(handler, config)
      config.action_methods || own_public_methods(handler)
    end

    # TODO: Merge args suppliers.
    private def args_supplier(config)
      return @default_args_supplier if config.custom_args.empty?

      ActionHandler::Args.from_hash(config.custom_args)
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
