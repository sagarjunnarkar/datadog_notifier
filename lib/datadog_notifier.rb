require 'ddtrace'

class DatadogNotifier
  def self.notify(exception)
    root_span = find_root_span(Datadog::Tracing.active_span)
    root_span.set_error(exception)
  end

  def self.find_root_span(child_span)
    current_span = child_span
    current_span = current_span.send(:parent) while current_span.send(:parent)
    current_span
  end
end
