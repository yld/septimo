[![Build Status](https://travis-ci.org/yld/septimo.svg?branch=master)](https://travis-ci.org/yld/septimo)

# README

Septimo is a set of standalone opiniated generator dedicated to install and setup various testing and quality Rails and Ruby tools.
Those generators are designed bo be use within a Rails application or a Rails engine

## Install

Add septimo to your Gemfile in developement environment, ie from within your application (or engine root)
```sh
echo "gem 'septimo', group: :development" >> Gemfile
bundle install
```

## Included generators

  septimo:bundler
  septimo:cucumber
  septimo:ember
  septimo:factory_girl
  septimo:guard
  septimo:haml
  septimo:i18n
  septimo:json
  septimo:rack_mini_profiler
  septimo:reek
  septimo:rspec
  septimo:rubocop
  septimo:simple_cov
  septimo:zeus


# Getting help

```sh
cd my_app
rails g septimo:rspec --help
```

## Running a generator

Given you want to install rspec with zeus support into an application named my_app
```sh
cd my_app
rails g septimo:rspec --zeus
```
