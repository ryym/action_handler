# frozen_string_literal: true

require 'test_helper'

class SessionsHandlerTest < ActiveSupport::TestCase
  def handler
    SessionsHandler.new
  end

  test '#login redirects if user is not found' do
    assert_equal(
      ActionHandler::Call.new(:redirect_to, [
        urls.login_path,
        { alert: 'nobody does not exist' },
      ]),
      handler.login({ name: 'nobody' }, {}, nil),
    )
  end

  test '#login resets session on success' do
    user = User.create!(name: 'foo')
    session = {}
    is_reset = false
    reset_session = -> { is_reset = true }
    handler.login({ name: 'foo' }, session, reset_session)

    assert(is_reset, 'session must be reset')
    assert_equal(session, { user_id: user.id })
  end
end
