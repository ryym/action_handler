# frozen_string_literal: true

module ActionHandler
  class Installer
    attr_reader :ctrl_class
    private :ctrl_class

    def initialize(ctrl_class)
      @ctrl_class = ctrl_class
    end

    def install(handler)
      # unimplemented
    end
  end
end
