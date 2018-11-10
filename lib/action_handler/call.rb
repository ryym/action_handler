# frozen_string_literal: true

module ActionHandler
  class Call
    attr_reader :method_name
    attr_reader :args

    def initialize(method_name, args = [])
      raise ArgumentError, 'args must be an array' unless args.is_a?(Array)

      @method_name = method_name.to_sym
      @args = args.freeze
    end

    def call_with(receiver)
      receiver.send(method_name, *args)
    end

    # overrides
    def ==(other)
      other.is_a?(ActionHandler::Call) &&
        method_name == other.method_name &&
        args == other.args
    end

    # overrides
    def hash
      [method_name, args].hash
    end
  end
end
