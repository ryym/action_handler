# frozen_string_literal: true

module ActionHandler
  class ArgsMaker
    # TODO: Support optional arguments and keyword arguments.

    def make_args(parameters, supplier)
      parameters.inject([]) do |values, (_, name)|
        unless supplier.respond_to?(name)
          raise ArgumentError, "parameter #{name} is not defined in #{supplier}"
        end

        values << supplier.send(name)
      end
    end
  end
end
