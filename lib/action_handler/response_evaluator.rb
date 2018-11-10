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
      when nil
        nil
      else
        raise "unsupported response: #{res}"
      end
    end
  end
end
