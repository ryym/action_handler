# frozen_string_literal: true

module ActionHandler
  # ResponseEvaluator evaluates and converts handler return values.
  class ResponseEvaluator
    def evaluate(ctrl, res)
      case res
      when Hash
        ctrl.render(res)
      when ActionHandler::Call
        res.call_with(ctrl)
      end
    end
  end
end
