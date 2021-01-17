class DummyEvent < EventRouter::Event
  deliver_to :dummy_handler_1, handler: nil
  deliver_to :dummy_handler_2, handler: nil, prefetch_payload: true

  def dummy_handler_1_payload
    { id: 't1' }
  end

  def dummy_handler_2_payload
    { id: 't2' }
  end
end
