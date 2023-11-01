# Service functions
 Hello. This repo contains source code for medium article [Service Objects as functions: a functional approach to build business flows in Ruby On Rails](https://medium.com/@beard-programmer/service-objects-as-functions-a-functional-approach-to-build-business-flows-in-ruby-on-rails-bf34bf18331d)

[![Ruby CI](https://github.com/beard-programmer/service-functions/actions/workflows/main.yml/badge.svg)](https://github.com/beard-programmer/service-functions/actions/workflows/main.yml)

## Dependencies
 - Ruby 3.2.2
## How to run
1. Install Ruby 3.2.2
2. Install gem bundle
3. Clone repo
4. Run bundle install to install dependencies
5. Run tests using rspec `bundle exec rspec`

## Contents
- [app](app) - original code from the article showcasing service functions pattern
- [app/handle_errors/exceptions](app/handle_errors/exceptions) - service functions pattern with Ruby way of error handling using exceptions
- [app/handle_errors/ok_error](app/handle_errors/ok_error) - service functions pattern with Elixir style error handling

## Related projects
- Service functions in [Ruby](https://github.com/beard-programmer/service-functions) this is original source that was used in Medium article (this repo)
- Service functions in [Golang](https://github.com/beard-programmer/service-functions-go)
- Service functions in [Elixir](https://github.com/beard-programmer/service-functions-elixir)
