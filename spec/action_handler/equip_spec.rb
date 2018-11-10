# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::Equip do
  it 'provides #render' do
    ctrl_class = Class.new do
      include ActionHandler::Equip

      def index
        render status: :ok, json: [1, 2]
      end
    end

    ctrl = ctrl_class.new
    expect(ctrl.index).to eq(status: :ok, json: [1, 2])
  end

  it 'provides #redirect_to' do
    ctrl_class = Class.new do
      include ActionHandler::Equip

      def index
        redirect_to '/a/b/c', alert: :abc
      end
    end

    ctrl = ctrl_class.new
    expect(ctrl.index).to eq(
      ActionHandler::Call.new(:redirect_to, ['/a/b/c', { alert: :abc }]),
    )
  end

  # Skip for now because we need Rails environment to test this.
  # it "provides #urls"
end
