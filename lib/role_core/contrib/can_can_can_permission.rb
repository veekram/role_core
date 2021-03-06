# frozen_string_literal: true

module RoleCore
  class CanCanCanPermission < RoleCore::Permission
    attr_reader :action, :options

    def initialize(name, _namespace: [], _priority: 0, _callable: true, **options, &block)
      super
      return unless _callable

      @model = options[:model] || options.fetch(:model_name).constantize
      @action = options[:action] || name
      @options = options.except(:model, :model_name, :action)
      @block = block
    end

    def call(context, *args)
      return unless callable

      if block_attached?
        context.can @action, @model, &@block.curry[*args]
      else
        context.can @action, @model, @options
      end
    end

    def block_attached?
      !!@block
    end
  end
end
