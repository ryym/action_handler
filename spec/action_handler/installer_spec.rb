# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::Installer do
  describe '#install' do
    it 'registers same name public methods' do
      class Handler
        def index
          { status: :ok }
        end

        def show
          { json: :hello }
        end
      end

      Ctrl = Class.new
      ActionHandler::Installer.new(Ctrl).install(Handler.new)
      ctrl = Ctrl.new

      expect(ctrl.index).to eq(status: :ok)
      expect(ctrl.show).to eq(json: :hello)
    end
  end
end
