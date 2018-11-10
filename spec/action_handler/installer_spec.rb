# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::Installer do
  describe '#install' do
    it 'registers same name public methods' do
      handler_class = Class.new do
        def index
          { status: :ok }
        end

        def show
          { json: :hello }
        end
      end

      ctrl_class = Class.new
      installer = ActionHandler::Installer.new(ctrl_class)
      installer.install(handler_class.new)
      ctrl = ctrl_class.new

      expect(ctrl.index).to eq(status: :ok)
      expect(ctrl.show).to eq(json: :hello)
    end
  end
end
