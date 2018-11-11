# frozen_string_literal: true

module ActionHandler
  module Args
    module_function def from_hash(name_to_proc)
      klass = Class.new do
        name_to_proc.each do |name, proc|
          define_method(name, &proc)
        end
      end

      klass.new
    end
  end
end
