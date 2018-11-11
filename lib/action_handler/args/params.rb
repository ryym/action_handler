# frozen_string_literal: true

module ActionHandler
  module Args
    class Params
      def initialize(*names, **nested_params)
        names.each do |name|
          define_singleton_method(name) do |ctrl|
            ctrl.params[name]
          end
        end

        nested_params.each do |name, fields|
          define_singleton_method(name) do |ctrl|
            ctrl.params.require(name).permit(*fields)
          end
        end
      end
    end
  end
end
