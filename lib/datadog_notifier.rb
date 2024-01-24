# frozen_string_literal: true

require 'ddtrace'
require 'datadog_notifier_exception'

class DatadogNotifier
  def self.notify(exception, payload = {})
    root_span = find_root_span(Datadog::Tracing.active_span)
    exception = DatadogNotifierException.new exception if exception.is_a?(String)
    root_span.set_error(exception)
    root_span.set_tag('custom_dd_notifier', true)
    root_span.set_tag('payload', payload.to_json) if payload.present?
  end

  def self.find_root_span(child_span)
    current_span = child_span
    current_span = current_span.send(:parent) while current_span.send(:parent)
    current_span
  end
end
