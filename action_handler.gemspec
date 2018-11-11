# frozen_string_literal: true

require_relative 'lib/action_handler/version'

Gem::Specification.new do |s|
  s.name = 'action_handler'
  s.version = ActionHandler::VERSION
  s.authors = ['ryym']
  s.email = ['ryym.64@gmail.com']
  s.homepage = 'https://github.com/ryym/action_handler'
  s.summary = 'Rails controller alternative'
  s.description = 'This makes your controllers more unit-testable.'
  s.license = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'rubocop', '>= 0.49'
end
