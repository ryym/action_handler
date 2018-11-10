# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::ArgsMaker do
  describe '#make_args' do
    it 'makes argument values' do
      supplier_class = Class.new do
        def a
          [:alice, 1]
        end

        def b
          { bob: true }
        end

        def c
          :unused
        end
      end

      user_class = Class.new do
        def use(b, a)
          [a[1], b[:bob]]
        end
      end

      user = user_class.new
      params = user.method(:use).parameters

      maker = ActionHandler::ArgsMaker.new
      values = maker.make_args(params, supplier_class.new)

      expect(values).to eq([{ bob: true }, [:alice, 1]])
      expect(user.use(*values)).to eq([1, true])
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
        params = user.method(:use).parameters

        maker = ActionHandler::ArgsMaker.new
        values = maker.make_args(params, supplier_class.new, context: 'world')

        expect(values).to eq(['hello world', 'goodbye world'])
        expect(user.use(*values)).to eq('hello world!! goodbye world!!')
      end
    end
  end
end
