# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'minitest/mock'

ActionHandler.autoload_handlers_from_controller_file

module ActiveSupport
  class TestCase
    def urls
      Rails.application.routes.url_helpers
    end

    setup do
      DatabaseRewinder.clean_all
    end

    teardown do
      DatabaseRewinder.clean
    end
  end
end
