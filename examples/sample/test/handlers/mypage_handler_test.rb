# frozen_string_literal: true

require 'test_helper'

class MypageHandlerTest < ActiveSupport::TestCase
  test '#index returns welcome message' do
    user = User.new(name: 'foo')

    mock_greeter = Class.new do
      def welcome(user, theme)
        "mock-welcome-#{user.name}-#{theme}"
      end
    end.new

    handler = MypageHandler.new(greeter: mock_greeter)

    assert_equal(
      {
        locals: {
          user: user,
          welcome: 'mock-welcome-foo-cool',
        },
      },
      handler.index(user, 'cool'),
    )
  end
end
