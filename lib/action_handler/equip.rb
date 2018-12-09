# frozen_string_literal: true

require 'action_handler/call'
require 'action_handler/args/default'

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
      handler_class.args ActionHandler::Args::Default.new
    end
  end

  module HandlerExtension
    def as_controller(&block)
      ActionHandler::Config.get(self).as_controller = block
    end

    def action_methods(*method_names)
      ActionHandler::Config.get(self).action_methods = method_names
    end

    def args(*suppliers)
      raise '`args` does not accept block. Use `arg` to define custom argument' if block_given?

      config = ActionHandler::Config.get(self)
      suppliers.each do |supplier|
        config.add_args_supplier(supplier)
      end
    end

    def args_params(*names)
      ActionHandler::Config.get(self).add_args_supplier(
        ActionHandler::Args::Params.new(*names),
      )
    end

    def arg(name, &block)
      unless block_given?
        raise '`arg` requires block. Use `args` to register arguments supplier object'
      end

      ActionHandler::Config.get(self).add_arg(name, &block)
    end
  end
end
