# frozen_string_literal: true

module ActionHandler
  class ArgsMaker
    # TODO: Support keyword arguments.
    def make_args(parameters, supplier, context: nil)
      supplier_args = [context].compact
      parameters.inject([]) do |values, (_, name)|
        unless supplier.respond_to?(name)
          raise ArgumentError, "parameter #{name} is not defined in #{supplier}"
        end

        values << supplier.send(name, *supplier_args)
      end
    end
  end
end
