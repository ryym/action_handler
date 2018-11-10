# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::Controller do
  it 'provides .use_handler class method' do
    Class.new do
      include ActionHandler::Controller
      use_handler { nil }
    end
  end
end
