# frozen_string_literal: true

require 'action_handler/installer'

module ActionHandler
  module Controller
    def self.included(ctrl_class)
      ctrl_class.extend ActionHandler::ControllerExtension
    end
  end

  module ControllerExtension
    def use_handler(&block)
      ActionHandler::Installer.new.install(self, &block)
    end
  end
end
