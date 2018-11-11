# frozen_string_literal: true

require 'test_helper'

class PingsHandlerTest < ActiveSupport::TestCase
  def handler
    PingsHandler.new
  end

  test '#index returns pong' do
    assert_equal(
      { locals: { pong: :pong_from_handler } },
      handler.index,
    )
  end

  test '#show responds to json format' do
    params = { id: 3 }
    assert_equal(
      {
        json: { id: 3, pong: 'pong by 3' },
      },
      handler.show(params, :json),
    )
  end

  test '#show returns plain text if format is not json' do
    assert_equal({ plain: 'Pong!' }, handler.show({}, :html))
  end
end
