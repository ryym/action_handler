# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::ArgsMaker do
  describe '#make_args' do
    def make_supplier(values)
      supplier_class = Class.new.tap do |cls|
        values.each do |name, value|
          cls.define_method(name) { value }
        end
      end
      supplier_class.new
    end

    it 'makes argument values' do
      supplier = make_supplier(
        a: [:alice, 1],
        b: { bob: true },
        c: :unused,
      )

      user_class = Class.new do
        def use(b, a)
          [a[1], b[:bob]]
        end
      end

      user = user_class.new

      maker = ActionHandler::ArgsMaker.new
      values = maker.make_args(user.method(:use), supplier)

      expect(values).to eq([{ bob: true }, [:alice, 1]])
      expect(user.use(*values)).to eq([1, true])
    end

    it 'supports keyword arguments' do
      supplier = make_supplier(a: :A, b: :B, c: :C, d: :D)

      user_class = Class.new do
        def use(a, c, d:, b:)
          [b, d, c, a].map(&:to_s).join
        end
      end

      maker = ActionHandler::ArgsMaker.new
      user = user_class.new
      values = maker.make_args(user.method(:use), supplier)

      expect(values).to eq([:A, :C, { d: :D, b: :B }])
      expect(user.use(*values)).to eq('BDCA')
    end

    it 'rejects optional arguments' do
      supplier = make_supplier(a: 1)
      user_class = Class.new do
        def use(a = 2)
          a
        end
      end

      maker = ActionHandler::ArgsMaker.new
      user = user_class.new
      expect { maker.make_args(user.method(:use), supplier) }.to raise_error(
        ActionHandler::ActionArgumentError,
      )
    end

    context 'with context' do
      it 'pass context to supplier methods' do
        supplier_class = Class.new do
          def hello(name)
            "hello #{name}"
          end

          def goodbye(name)
            "goodbye #{name}"
          end
        end

        user_class = Class.new do
          def use(hello, goodbye)
            "#{hello}!! #{goodbye}!!"
          end
        end

        user = user_class.new
        maker = ActionHandler::ArgsMaker.new
        values = maker.make_args(user.method(:use), supplier_class.new, context: 'world')

        expect(values).to eq(['hello world', 'goodbye world'])
        expect(user.use(*values)).to eq('hello world!! goodbye world!!')
      end
    end
  end
end
