class DummyHandler
  def self.dummy_event(event:, payload:); end

  def self.custom_handler(event:, payload:); end
end

class DummyEvent < EventRouter::Event
  deliver_to :default_handler, handler: DummyHandler
  deliver_to :custom_handler, handler: DummyHandler, handler_method: :custom_handler
  deliver_to :enabled_prefetch, handler: DummyHandler, prefetch_payload: true

  def default_handler_payload
    { id: 't1' }
  end

  def custom_handler_payload
    { id: 't2' }
  end

  def enabled_prefetch_payload
    { id: 't3' }
  end
end
