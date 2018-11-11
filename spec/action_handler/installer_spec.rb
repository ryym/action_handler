# frozen_string_literal: true

require 'spec_helper'

# This class is a main logic of this library.
# So these tests are almost integration tests.
# We think this is enough to test this small library.
describe ActionHandler::Installer do
  let(:noop_res_evaluator) do
    Class.new do
      def evaluate(_ctrl, res)
        res
      end
    end.new
  end

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
      include ActionHandler::Equip

      def show(params, session)
        { params: params, session: session }
      end
    end

    ctrl_class = Class.new do
      def session
        :session
      end

      def params
        { id: 1 }
      end
    end

    installer = ActionHandler::Installer.new(res_evaluator: noop_res_evaluator)
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

  context 'when args suppliers are specified' do
    it 'merges them with the default supplier' do
      args_supplier_class = Class.new do
        def initialize(prefix)
          @prefix = prefix
        end

        def name(ctrl)
          "#{@prefix}#{ctrl.params[:name]}"
        end
      end

      handler_class = Class.new do
        include ActionHandler::Equip

        args args_supplier_class.new('Mr. ')

        def show(name, params)
          { name: name, params: params }
        end
      end

      ctrl_class = Class.new do
        def params
          { name: 'Ryu' }
        end
      end

      installer = ActionHandler::Installer.new(res_evaluator: noop_res_evaluator)
      installer.install(handler_class.new, ctrl_class)
      ctrl = ctrl_class.new

      expect(ctrl.show).to eq(
        name: 'Mr. Ryu',
        params: { name: 'Ryu' },
      )
    end
  end

  context 'when custom args are specified' do
    it 'merges them with the arguments suppliers' do
      args_supplier_class = Class.new do
        def name(ctrl)
          ctrl.params[:name]
        end
      end

      handler_class = Class.new do
        include ActionHandler::Equip

        args args_supplier_class.new

        arg(:id) do |ctrl|
          ctrl.params[:id]
        end

        def show(id, cookies, name)
          { id: id, name: name, cookie: cookies[:cookie] }
        end
      end

      ctrl_class = Class.new do
        def params
          { id: 333, name: 'Gon' }
        end

        def cookies
          { cookie: :cookie }
        end
      end

      installer = ActionHandler::Installer.new(res_evaluator: noop_res_evaluator)
      installer.install(handler_class.new, ctrl_class)
      ctrl = ctrl_class.new

      expect(ctrl.show).to eq(id: 333, name: 'Gon', cookie: :cookie)
    end

    it 'overrides same name suppliers' do
      args_supplier_class = Class.new do
        def name(ctrl)
          ctrl.params[:name]
        end
      end

      handler_class = Class.new do
        include ActionHandler::Equip

        args args_supplier_class.new

        arg(:name) do |ctrl|
          "override #{ctrl.params[:name]}"
        end

        def show(name)
          { name: name }
        end
      end

      ctrl_class = Class.new do
        def params
          { name: 'Foo' }
        end
      end

      installer = ActionHandler::Installer.new(res_evaluator: noop_res_evaluator)
      installer.install(handler_class.new, ctrl_class)
      ctrl = ctrl_class.new

      expect(ctrl.show).to eq(name: 'override Foo')
    end
  end

  context 'when args_params are specified' do
    it 'supplies specified param values' do
      handler_class = Class.new do
        include ActionHandler::Equip

        args_params :a, :c, lang: %i[name author]

        def show(params, a, c, lang)
          { got: [a, c], lang: lang, count: params.size }
        end
      end

      ctrl_class = Class.new do
        def params
          lang = { name: 'Ruby', author: 'Matz', color: 'red' }
          MockParams.new(a: 1, b: 2, c: 3, lang: lang)
        end
      end

      installer = ActionHandler::Installer.new(res_evaluator: noop_res_evaluator)
      installer.install(handler_class.new, ctrl_class)
      ctrl = ctrl_class.new

      expect(ctrl.show).to eq(
        got: [1, 3],
        lang: { name: 'Ruby', author: 'Matz' },
        count: 4,
      )
    end
  end

  context 'when as_controller is specified' do
    it 'runs given block inside of controller' do
      handler_class = Class.new do
        include ActionHandler::Equip

        as_controller do
          @something = :some_value
        end

        arg(:something) do |ctrl|
          ctrl.class.instance_variable_get(:@something)
        end

        def show(something)
          { got: something }
        end
      end

      ctrl_class = Class.new
      installer = ActionHandler::Installer.new(res_evaluator: noop_res_evaluator)
      installer.install(handler_class.new, ctrl_class)
      ctrl = ctrl_class.new

      expect(ctrl.show).to eq(got: :some_value)
    end
  end
end
