# frozen_string_literal: true

module ActionHandler
  # DefaultArgs is a default arguments supplier for handler methods.
  class DefaultArgs
    %i[params request response cookies flash session remove_session logger].each do |key|
      define_method(key) do |ctrl|
        ctrl.send(key)
      end
    end

    def format(ctrl)
      ctrl.request.format
    end
  end
end
