# frozen_string_literal: true

require 'test_helper'

class UsersHandlerTest < ActiveSupport::TestCase
  def handler
    UsersHandler.new
  end

  test '#index returns all users' do
    User.create!(name: :a)
    User.create!(name: :b)
    res = handler.index
    assert_equal(res[:locals][:users].map(&:name), %w[a b])
  end

  test '#show reutrns single user' do
    user = User.new(name: :bob)

    # You can stub DB access as well.
    User.stub :find, user do
      assert_equal(
        { locals: { user: user } },
        handler.show(id: 1),
      )
    end
  end

  test '#create creates new user and redirect' do
    res = handler.create(name: 'foo')
    user = User.find_by(name: 'foo')

    assert_not_nil(User.find_by(name: 'foo'))
    assert_equal(
      ActionHandler::Call.new(:redirect_to, [urls.user_path(user)]),
      res,
    )
  end
end
