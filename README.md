[![Gem Version](https://badge.fury.io/rb/anycable-rails-jwt.svg)](https://rubygems.org/gems/anycable-rails-jwt)
[![Build](https://github.com/anycable/anycable-rails-jwt/workflows/Build/badge.svg)](https://github.com/anycable/anycable-rails-jwt/actions)

# Anycable Rails JWT

AnyCable Rails helpers for [JWT-based identification](https://docs.anycable.io/anycable-go/jwt_identification) from [AnyCable PRO][pro].

## Installation

Add gem to your project:

```ruby
# Gemfile
gem "anycable-rails-jwt"
```

## Usage

### Configuration

This gem extends AnyCable configuration and adds the following new parameters:

- `jwt_id_key`: JWT encryption key used to sign tokens (required).
- `jwt_id_param`: the name of the query string parameter to carry tokens (defaults to `jid`).
- `jwt_id_ttl`: the number of seconds for a token to live (defaults to 3600, one hour).

You can specify these parameters in `config/anycable.yml`, credentials, ENV or whatever source of configuration you use for AnyCable.

### `action_cable_with_jwt_meta_tag`

In order to generate a token and pass it to a client, you can use an HTML meta tag similar to the built-in `#action_cable_meta_tag`:

```erb
<%= action_cable_with_jwt_meta_tag(current_user: current_user) %> would render:
# => <meta name="action-cable-url" content="ws://demo.anycable.io/cable?token=eyJhbGciOiJIUzI1NiJ9....EWCEzziOx3sKyMoNzBt20a3QvhEdxJXCXaZsA-f-UzU" />
```

You must pass all the required identifiers you have in your `ApplicationCable::Connection` class.

### `AnyCable::Rails::JWT.encode`

Alternatively, you can generate a token and deliver it to a client the way you prefer. For that, you can use `AnyCable::Rails::JWT.encode` method:

```ruby
AnyCable::Rails::JWT.encode(current_user: current_user) #=> <token>

# you can also override the global TTL setting via expires_at option
AnyCable::Rails::JWT.encode(current_user: current_user, expires_at: 10.minutes.from_now)
```

### Decoding tokens and using without AnyCable

Although the main purpose of this library is to add AnyCable PRO identification support, it's possible to use JWT-based authentication without AnyCable at all. For that, you can do something like this in your `ApplicationCable::Connection` class:

```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      token = request.params[:jid]

      identifiers = AnyCable::Rails::JWT.decode(token)
      identifiers.each do |k, v|
        public_send("#{k}=", v)
      end
    rescue JWT::DecodeError
      reject_unauthorized_connection
    end
  end
end
```

In AnyCable a token's TTL is checked by the `anycable-go` server. In case the token is expired, the server [would disconnect with a specific reason](https://anycable.io/blog/jwt-identification-and-hot-streams/) `token_expired`.

To mimic this behavior without AnyCable, you can add a simple patch to your application connection:

```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # ...

    private

    # Overload the +ActionCable::Connection::Base+ to handle JWT expiration
    # as rejected connection with a specific reason.
    # (in AnyCable this check is <also> done by the `anycable-go` server).
    def handle_open
      super
    rescue JWT::ExpiredSignature
      logger.error "An expired JWT token was rejected"
      close(reason: "token_expired", reconnect: false) if websocket.alive?
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/anycable/anycable-rails-jwt](https://github.com/anycable/anycable-rails-jwt).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[pro]: https://anycable.io/#pro
