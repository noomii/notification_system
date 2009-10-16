Notifications
=============

The Noomii notification system!

TODO
----

1. add configuration class for things like mailer
2. update this README
3. rename plugin!
4. notifications should be associated to events

Installation
------------

    script/generate notifications_migration
    rake db:migrate

Usage
-----

### Creating New Events ###

    script/generate event NewUser

This will generate `app/models/events/new_user_event.rb`, and `app/views/notification_mailer/new_user.erb`

### Triggering Events ###

    NewUserEvent.trigger :source => source_object

### Event Subscription ###

To subscribe / unsubscribe to events:

    user.subscribe_to_event(NewUserEvent)
    user.unsubscribe_from_event(NewUserEvent)

To subscribe without email:

    user.subscribe_to_event(NewUserEvent, false)

To check subscription:

    user.subscribed_to_event?(EventName)

To customize conditions for checking whether a user is subscribed, override `CoolEvent.subscribers` (a protected method), in your event subclasses.


Naming Scheme
-------------

The event base clase is called `CoolEvent` because there already exists an `Event` class; however, we still use `Event` instead of `CoolEvent` whereever we can.

Copyright (c) 2009 Radu Vlad, released under the MIT license
