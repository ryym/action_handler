# frozen_string_literal: true

module ActionHandler
  class ActionArgumentError < StandardError
    def initialize(method, details)
      super("Arguments of #{method.owner.name}##{method.name} is invalid: #{details}")
    end
  end

  class ArgsMaker
    def make_args(method, supplier, context: nil)
      supplier_args = [context].compact

      values = []
      keywords = {}

      method.parameters.each do |kind, name|
        unless supplier.respond_to?(name)
          raise ActionHandler::ActionArgumentError.new(
            method,
            "parameter #{name} is not defined in #{supplier}",
          )
        end

        case kind
        when :req
          values << supplier.send(name, *supplier_args)
        when :keyreq
          keywords[name] = supplier.send(name, *supplier_args)
        when :opt, :key
          raise ActionHandler::ActionArgumentError.new(method, <<~ERR)
            Do not use optional arguments.
            ActionHandler always injects arguments even if the value is nil,
            so the optional values never be used.
          ERR
        when :rest, :keyrest
          raise ActionHandler::ActionArgumentError.new(
            method,
            'rest arguments cannot be used',
          )
        end
      end

      values << keywords unless keywords.empty?
      values
    end
  end
end
