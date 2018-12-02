# frozen_string_literal: true

module ActionHandler
  class ActionArgumentError < StandardError
    def initialize(details = '')
      super("Invalid handler action method arguments: #{details}")
    end
  end

  class ArgsMaker
    def make_args(parameters, supplier, context: nil)
      supplier_args = [context].compact

      values = []
      keywords = {}

      parameters.each do |kind, name|
        unless supplier.respond_to?(name)
          raise ActionHandler::ActionArgumentError,
            "parameter #{name} is not defined in #{supplier}"
        end

        case kind
        when :req
          values << supplier.send(name, *supplier_args)
        when :keyreq
          keywords[name] = supplier.send(name, *supplier_args)
        when :opt, :key
          raise ActionHandler::ActionArgumentError, <<~ERR
            Do not use optional arguments.
            ActionHandler always injects arguments even if the value is nil,
            so the optional values never be used.
          ERR
        when :rest, :keyrest
          raise ActionHandler::ActionArgumentError, 'rest arguments cannot be used'
        end
      end

      values << keywords unless keywords.empty?
      values
    end
  end
end
