# frozen_string_literal: true

require_relative 'lib/action_handler/version'

Gem::Specification.new do |s|
  s.name = 'action_handler'
  s.version = ActionHandler::VERSION
  s.authors = ['ryym']
  s.email = ['ryym.64@gmail.com']
  s.homepage = 'https://github.com/ryym/action_handler'
  s.summary = 'Rails controller alternative'
  s.description = 'Makes your controllers more unit-testable.'
  s.license = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rspec_junit_formatter', '~> 0'
  s.add_development_dependency 'rubocop', '~> 0.60'
end
