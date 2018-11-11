# frozen_string_literal: true

class MypageService
  def welcome(user, theme = nil)
    case theme&.to_sym
    when :passion
      "WELCOME, #{user.name}!! I LOVE YOU!"
    when :cool
      "Hey, #{user.name}"
    else
      "Welcome, #{user.name}!"
    end
  end
end
