# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::Args::Params do
  it 'defines param suppliers' do
    consumer = Class.new do
      def use(id, name); end
    end.new

    ctrl = Class.new do
      def params
        { id: 5, name: 'foo', age: 10 }
      end
    end.new

    supplier = ActionHandler::Args::Params.new(:id, :name)
    maker = ActionHandler::ArgsMaker.new
    args = maker.make_args(consumer.method(:use).parameters, supplier, context: ctrl)

    expect(args).to eq([5, 'foo'])
  end
end
