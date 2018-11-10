# frozen_string_literal: true

module ActionHandler
  module Controller
    def self.included(ctrl)
      ctrl.extend ActionHandler::ControllerExtension
    end
  end

  module ControllerExtension
    def use_handler
      yield # unimplemented
    end
  end
end
