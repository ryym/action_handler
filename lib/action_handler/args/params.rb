# frozen_string_literal: true

module ActionHandler
  module Args
    class Params
      def initialize(*names)
        define(names)
      end

      private def define(names)
        names.each do |name|
          define_singleton_method(name) do |ctrl|
            ctrl.params[name]
          end
        end
      end
    end
  end
end
