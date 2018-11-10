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
  end
end
