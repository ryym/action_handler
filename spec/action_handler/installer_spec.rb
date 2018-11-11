# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::Installer do
  let(:noop_res_evaluator) do
    Class.new do
      def evaluate(_ctrl, res)
        res
      end
    end.new
  end

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
      installer = ActionHandler::Installer.new(res_evaluator: noop_res_evaluator)
      installer.install(handler_class.new, ctrl_class)
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

      installer = ActionHandler::Installer.new(
        res_evaluator: noop_res_evaluator,
        args_supplier: args_supplier.new,
      )
      installer.install(handler_class.new, ctrl_class)
      ctrl = ctrl_class.new

      expect(ctrl.show).to eq(
        params: { id: 1 },
        session: :session,
      )
    end

    context 'when action methods are specified' do
      it 'adds these methods only' do
        handler_class = Class.new do
          include ActionHandler::Equip

          action_methods :a, :c

          def a; end

          def b; end

          def c; end
        end

        ctrl_class = Class.new
        installer = ActionHandler::Installer.new
        installer.install(handler_class.new, ctrl_class)
        ctrl = ctrl_class.new

        expect(
          a: ctrl.respond_to?(:a),
          b: ctrl.respond_to?(:b),
          c: ctrl.respond_to?(:c),
        ).to eq(a: true, b: false, c: true)
      end
    end

    context 'when custom args are specified' do
      it 'constructs custom arguments supplier' do
        handler_class = Class.new do
          include ActionHandler::Equip

          arg(:id) do |ctrl|
            ctrl.params[:id]
          end

          def show(id)
            render locals: { id: id }
          end
        end

        ctrl_class = Class.new do
          def params
            { id: 333 }
          end
        end

        installer = ActionHandler::Installer.new(res_evaluator: noop_res_evaluator)
        installer.install(handler_class.new, ctrl_class)
        ctrl = ctrl_class.new

        expect(ctrl.show).to eq(locals: { id: 333 })
      end
    end
  end
end
