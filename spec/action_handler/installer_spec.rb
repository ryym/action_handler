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
      ActionHandler::Installer.new.install(handler_class.new, ctrl_class)
      ctrl = ctrl_class.new

      expect(ctrl.index).to eq(status: :ok)
      expect(ctrl.show).to eq(json: :hello)
    end

    it 'auto injects some arguments' do
      handler_class = Class.new do
        def show(params, session)
          { params: params, session: session }
        end
      end

      ctrl_class = Class.new do
        def params
          { id: 1 }
        end
      end

      args_supplier = Class.new do
        def session(_ctrl)
          :session
        end

        def params(ctrl)
          ctrl.params
        end
      end

      installer = ActionHandler::Installer.new(args_supplier: args_supplier.new)
      installer.install(handler_class.new, ctrl_class)
      ctrl = ctrl_class.new

      expect(ctrl.show).to eq(
        params: { id: 1 },
        session: :session,
      )
    end
  end
end
