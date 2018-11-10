# frozen_string_literal: true

module ActionHandler
  class Installer
    attr_reader :ctrl_class
    private :ctrl_class

    def initialize(ctrl_class)
      @ctrl_class = ctrl_class
    end

    def install(handler)
      actions = own_public_methods(handler)
      actions.each do |name|
        @ctrl_class.send(:define_method, name) do
          handler.method(name).call
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
