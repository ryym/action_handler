# frozen_string_literal: true

require 'action_handler/installer'

module ActionHandler
  module Controller
    def self.included(ctrl)
      ctrl.extend ActionHandler::ControllerExtension
    end
  end

  module ControllerExtension
    def use_handler
      handler = yield
      ActionHandler::Installer.new(self).install(handler)
    end
  end
end
