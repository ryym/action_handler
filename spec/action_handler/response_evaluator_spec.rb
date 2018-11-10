# frozen_string_literal: true

require 'spec_helper'

describe ActionHandler::ResponseEvaluator do
  describe '#evaluate' do
    it 'passes response to Controller#render' do
      ctrl = Class.new do
        def render(opts)
          { rendered: true, opts: opts }
        end
      end.new

      evaluator = ActionHandler::ResponseEvaluator.new
      res = evaluator.evaluate(ctrl, status: :ok)
      expect(res).to eq(rendered: true, opts: { status: :ok })
    end

    context 'when response is lazy call' do
      it 'calls specified controller method' do
        ctrl = Class.new do
          def redirect_to(url)
            "redirect_to #{url}"
          end
        end.new

        evaluator = ActionHandler::ResponseEvaluator.new
        call = ActionHandler::Call.new(:redirect_to, ['/hoge'])
        res = evaluator.evaluate(ctrl, call)
        expect(res).to eq('redirect_to /hoge')
      end
    end
  end
end
