module ActionHandler
  module Proto
    def use_handler
      controller = self
      handler = yield

      config = handler.class.instance_variable_get(:@_action_handler_config)
      config = ActionHandler::Proto::Config.new if config.nil?

      actions = config.action_methods
      if actions.nil?
        actions = handler.public_methods
        handler.class.ancestors.drop(1).each do |anc|
          actions -= anc.instance_methods
        end
      end

      if config.as_controller.is_a?(Proc)
        controller.class_eval &config.as_controller
      end

      if config.action_args.is_a?(Proc)
        make_args = config.action_args
      else
        make_args = lambda { |_action, ctrl|
          [ctrl.params]
        }
      end

      actions.each do |name|
        controller.send(:define_method, name) do
          args = make_args.call(name.to_sym, self) || [params]
          raise "#{handler.class.name}.args must return an array" unless args.is_a?(Array)

          method = handler.method(name)
          args = [] if method.parameters.size == 0
          ret = method.call(*args)
          case ret
          when Hash
            render ret
          when ProxyCmd
            send(ret.cmd, *ret.args)
          end
        end
      end
    end

    Proto::Config = Struct.new(:as_controller, :action_args, :action_methods)

    class ProxyCmd
      attr_reader :cmd, :args
      def initialize(cmd, args)
        @cmd = cmd
        @args = args
      end
    end

    module Support
      extend ActiveSupport::Concern

      def render(hash)
        hash
      end

      def redirect_to(*args)
        ProxyCmd.new(:redirect_to, args)
      end

      def url_helpers
        Rails.application.routes.url_helpers
      end

      included do
        @_action_handler_config = ::ActionHandler::Proto::Config.new
      end

      class_methods do
        def as_controller(&block)
          @_action_handler_config.as_controller = block
        end

        def action_args(&block)
          @_action_handler_config.action_args = block
        end

        def action_methods(method_names)
          @_action_handler_config.action_methods = method_names
        end
      end
    end
  end
end
