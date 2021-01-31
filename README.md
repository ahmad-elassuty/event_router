# EventRouter

[![Gem Version](https://badge.fury.io/rb/event_router.svg)](https://badge.fury.io/rb/event_router)
![Specs](https://github.com/ahmad-elassuty/event_router/workflows/Specs/badge.svg)

EventRouter helps you organise your application domain events in a simple and intuitive way.

One domain event can have multiple side-effects in your system, for example sending emails, creating notifications, tasks, audit logs, event store, updating other system resources async and many more. EventRouter will help you create dedicated classes for your events, that can be consumed by multiple destinations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'event_router'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install event_router

EventRouter is pre-configured with some defaults. Please check the [Wiki](https://github.com/ahmad-elassuty/event_router/wiki/Configurations) for more info on how to update the configurations.

## Usage

It is very easy to create a new domain event and deliver it to multiple destinations:

- Create your new domain event and define the destination:

  ```ruby
  class OrderPlaced < EventRouter::Event
    deliver_to :email_notifier, handler: EmailNotifier
  end
  ```

- Create your handler:

  ```ruby
  class EmailNotifier
    def self.order_placed(event:, payload:)
      # [TODO] Handle the event here
    end
  end
  ```

- Publish your event:

  ```ruby
  OrderPlaced.publish(order_id: 1, time: Time.now)
  ```

  Also you can publish the event async:

  ```ruby
  OrderPlaced.publish_async(order_id: 1, time: Time.now)
  ```

And your are done! 🎉

An event can also define multiple destinations and each destination can have different set of options:

```ruby
class OrderPlaced < EventRouter::Event
  deliver_to :email_notifier, handler: EmailNotifier
  deliver_to :event_store, handler: EventStore, handler_method: :custom_method
end
```

For the full list of options, please check the [Wiki](https://github.com/ahmad-elassuty/event_router/wiki/Events-And-Destinations) 📚.

### Delivery Adapters

You can configure how your events are delivered to their consumers. EventRouter currently supports two different delivery adapters:

- [x] Sync (default)
- [x] [Sidekiq](https://github.com/mperham/sidekiq)

The `sync` adapter is the default delivery adapter. To asynchronously process your event, please use other backends e.g Sidekiq, or create your own custom adapter.

To setup other adapters, please check the [Wiki](https://github.com/ahmad-elassuty/event_router/wiki/Configurations) 📚.

### Serializers

Similarly, you can configure how events are serialized before they are handed to the delivery backend. This is mainly to provide flexibility on how events are stored and maintain the objects structure on deserialization. EventRouter currently supports two serializer adapters:

- [x] Json (default)
- [x] [Oj](https://github.com/ohler55/oj)

To change the default serializer adapter, please check the [Wiki](https://github.com/ahmad-elassuty/event_router/wiki/Configurations) 📚.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ahmad-elassuty/event_router. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ahmad-elassuty/event_router/blob/master/CODE_OF_CONDUCT.md).

Special thanks to [Ivan](https://github.com/idanci) for doing code review 🔍

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EventRouter project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ahmad-elassuty/event_router/blob/master/CODE_OF_CONDUCT.md).
