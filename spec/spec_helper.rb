# frozen_string_literal: true

require 'action_handler'
require 'forwardable'

class MockParams
  extend Forwardable

  def_delegators(:@params, :size)

  def initialize(params)
    @params = params || {}
  end

  def [](key)
    @params[key]
  end

  def require(key)
    MockParams.new(@params[key])
  end

  def permit(*keys)
    @params.select { |k, _v| keys.include?(k) }
  end
end
