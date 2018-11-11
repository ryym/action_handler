# frozen_string_literal: true

require 'action_handler/call'

module ActionHandler
  # Equip implements most basic functionality of controller for handler.
  module Equip
    # Return the argument as is, because the actual rendering
    # is done in a controller. This just makes returning values more easy.
    # Without this:
    #
    #   { status: :ok, json: user.to_json }
    #
    # With this (no braces):
    #
    #   render status: :ok, json: user.to_json
    def render(props)
      props
    end

    def redirect_to(*args)
      ActionHandler::Call.new(:redirect_to, args)
    end

    def urls
      Rails.application.routes.url_helpers
    end

    def self.included(handler_class)
      ActionHandler::Config.set(handler_class, ActionHandler::Config.new)
      handler_class.extend ActionHandler::HandlerExtension
    end
  end

  module HandlerExtension
    def action_methods(*method_names)
      ActionHandler::Config.get(self).action_methods = method_names
    end

    def arg(name, &block)
      ActionHandler::Config.get(self).add_arg(name, &block)
    end
  end
end
