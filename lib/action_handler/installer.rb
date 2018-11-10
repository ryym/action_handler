# frozen_string_literal: true

module ActionHandler
  class Installer
    attr_reader :args_maker
    attr_reader :args_supplier

    def initialize(
      args_maker: ActionHandler::ArgsMaker.new,
      # TODO: Use default arguments supplier.
      args_supplier: nil
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
          args =
            if installer.args_supplier
              installer.args_maker.make_args(
                method.parameters,
                installer.args_supplier,
                context: self,
              )
            else
              []
            end
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
