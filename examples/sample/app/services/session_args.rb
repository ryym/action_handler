# frozen_string_literal: true

# Arguments supplier for action handler.
class SessionArgs
  include Singleton

  def current_user(ctrl)
    ctrl.current_user
  end
end
