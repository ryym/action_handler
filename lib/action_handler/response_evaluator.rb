# frozen_string_literal: true

module ActionHandler
  # ResponseEvaluator evaluates and converts handler return values.
  class ResponseEvaluator
    def evaluate(ctrl, res)
      case res
      when Hash
        evaluate_hash(ctrl, res)
      when nil
        nil
      else
        raise "unsupported response: #{res}"
      end
    end

    private def evaluate_hash(ctrl, res)
      method = res[:@call]
      return ctrl.send(method, *(res[:args] || [])) if method

      ctrl.render(res)
    end
  end
end
