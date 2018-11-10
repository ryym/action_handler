# frozen_string_literal: true

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
      { '@call': :redirect_to, args: args }
    end

    def urls
      Rails.application.routes.url_helpers
    end
  end
end
