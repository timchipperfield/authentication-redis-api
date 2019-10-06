# Redis Authentication API

## Overview

Authentication api with create, login and authorization/refresh functionality.

## Setup

* ensure you have Redis installed and running on your machine
* clone this repo
* run `bundle install`

## Tests

Utilizes the RSpec gem. Run `rspec` command to run the test suite.

## Design Considerations

The api consists of three endpoints:

1. `post /registrations`: allows a user to register and receive a token via a header which can be used to authenticate against. Existing users can't re-register and instead must login.
2. `post /logins`: allows an existing user with an expired auth token to login and receive a fresh token upon success.
3. `post /authorizations`: verifies whether an auth token is valid and refreshes that token on success.

## Gemfile Considerations

The package primarily utilized is `jwt_sessions` which handles JSON web token sessions using Redis. Additionaly, 'User' objects are stored using Redis rather than a database. The gems `bcrypt` and `strong_password` ensure that passwords are safe and secure.
