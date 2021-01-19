class DummyHandler
  def self.dummy_event(event:, payload:); end
  def self.custom_handler(event:, payload:); end
end

class DummyEvent < EventRouter::Event
  deliver_to :default_handler, handler: DummyHandler
  deliver_to :custom_handler, handler: DummyHandler, handler_method: :custom_handler

  def default_handler_payload
    { id: 't1' }
  end

  def custom_handler_payload
    { id: 't2' }
  end
end
