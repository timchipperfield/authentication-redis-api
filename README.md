# Redis Authentication API

## Overview

Authentication API with create, login and authorization/refresh functionality.

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

## Approach

I approached this by firstly spending time researching JWT solutions. Once I found the `jwt_sessions` gem, I followed their documentation and some examples from similar apis implementing this gem. I started with some basic specs for the login controller since it seemed like a critical piece which would be my proof of concept (since implementing it requires most of what's required for registrations anyways). At this point, I still hadn't seen an another application using `redis` for storing the user with JWT authentication.

Once I saw that my initial login solution was working, I added `bcrypt` and `strong_password` for security. I didn't start with these because I figured would be easier to implement. I then moved on to create and integration spec that would show that the login endpoint seamlessly worked with the authorizations endpoint. I moved on to the registrations controller at this point and once it was working, I spent further time refining my response bodies and refactoring after that.

## Gemfile Considerations

The package primarily utilized is `jwt_sessions` which handles JSON web token sessions using Redis. Additionaly, 'User' objects are stored using Redis rather than a database. The gems `bcrypt` and `strong_password` ensure that passwords are safe and secure.
