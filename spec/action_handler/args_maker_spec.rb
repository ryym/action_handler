# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::ArgsMaker do
  describe '#make_args' do
    it 'makes argument values' do
      class Def
        def a
          [:alice, 1]
        end

        def b
          { bob: true }
        end
      end

      class Consumer
        def use(b, a)
          [a[1], b[:bob]]
        end
      end

      consumer = Consumer.new
      params = consumer.method(:use).parameters

      maker = ActionHandler::ArgsMaker.new
      values = maker.make_args(params, Def.new)

      expect(values).to eq([{ bob: true }, [:alice, 1]])
      expect(consumer.use(*values)).to eq([1, true])
    end
  end
end
