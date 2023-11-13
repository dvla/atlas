# Atlas

Atlas provides a wrapper around the `World` functionality provided by Cucumber. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dvla-atlas'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dvla-atlas


## World overview

World is a [feature of Cucumber](https://github.com/cucumber/cucumber-ruby/blob/main/features/docs/writing_support_code/world.feature) that allows the user to influence the context within which test steps are run. By default, at the start of each scenario Cucumber calls `Object.new` and mixes in the RSpec assertions to get the context within which the test steps will be executed. Calling `World` allows this to be changed in one of two ways.

The first is by defining additional methods within a module and then mixing that into the object that the tests are run in the context of. For example, suppose we define the following module `Helper`:

```ruby
module Helper
  def foo
    'foo'
  end
end
```

If this module is then passed into World (`World(Helper)`), all steps that are run in that test pack will be able to call the method `foo` directly.

The second way to use World is to provide it with a block of code. This block will be called at the start of each Scenario, with the returned value being used in place of `Object.new`. For example, suppose we define the following class `Base`:

```ruby
class Base
  def initialize(base_value)
    @base_value = base_value
  end
  
  def add_to_base_value(value_to_add)
    value_to_add + @base_value
  end
  
  def set_base_value(new_base_value)
    @base_value = new_base_value
  end
end
```

The above can be used as the context for all tests with the following code:

```ruby
World do
  Base.new(2)
end
```

As this is run for each new scenario, the block will be run again and so the internal `base_value` will start off as 2 for each new test.

## Using Atlas

### Adding it to your tests

Atlas functions by providing the base class (in this instance called `TestArtefactory`) for tests to run in the context of. This features a single method called `artefacts` that returns an artefacts object upon which you can define variables that you wish to share across steps within the same scenario. Once you got the gem installed you can add the following to your `env.rb` file (or equivalent):

```ruby
World do
  DVLA::Atlas.base_world
end
```

However, the generated artefacts does not currently have any fields

### Adding fields to your artefact

For example, if you wanted all scenarios to have access to the string `foo` this could be set up in the following way when creating World:

```ruby
World do
  world = DVLA::Atlas.base_world
  world.artefacts.define_fields(foo: 'foo')
  world
end
```

This would allow any test step to make the following call and retrieve the value of 'foo' in the following way:

```ruby
artefacts.foo
```

Additionally, a setter for that variable will also exist, so a test could assign a different value to foo for the rest of the scenario if required, such as:

```ruby
artefacts.foo = 'bar'
```

It is also possible to create a variable in artefacts without assigning any value to it. For example, you could have the initial call to World that looks like this:

```ruby
World do
  world = DVLA::Atlas.base_world
  world.artefacts.define_fields('current_url')
  world
end
```

This would guarantee that `current_url` is accessible by all test steps, even if it does not start with a value.

### Exposing your own helper methods

If you've got some of your own helper methods you'd like to make available, you can define them in a module and mix that in with the world. You'd do that in the following way:

```ruby
World do
  world = DVLA::Atlas.base_world
  world.artefacts.define_fields('current_url', 'username', 'password')
  world
end

module Helpers
  def double(value)
    value * 2
  end
end

World(Helpers)
```

As well as the fields `current_url`, `username` and `password`, this would provide all test steps with access to the method `double`

### Accessing the artefact outside the scope of the test steps

If you need access to the artefact from somewhere other than directly in the steps and it is not feasible to pass it in from step method then it can be configured to be accessible globally. That is achieved by adding a call into `make_artefacts_global` when configuring World:

```ruby
World do
  world = DVLA::Atlas.base_world
  world.artefacts.define_fields('current_url', 'username', 'password')
  DVLA::Atlas.make_artefacts_global(world.artefacts)
  world
end
```

## Development

Atlas is quite lightweight. The functionality that deals with the creation of properties in with the test artefact is located within `artefacts.rb`. This project uses [Sorbet](https://sorbet.org/) for type checking. When making changes, don't forget to add tests.