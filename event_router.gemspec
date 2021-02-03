# frozen_string_literal: true

require_relative 'lib/event_router/version'

Gem::Specification.new do |spec|
  spec.name          = 'event_router'
  spec.version       = EventRouter::VERSION
  spec.authors       = ['Ahmad Elassuty']
  spec.email         = ['ahmad.elassuty@gmail.com']

  spec.summary       = 'Organise your application domain events side-effects in a simple and intuitive way.'
  spec.homepage      = 'https://github.com/ahmad-elassuty/event_router'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Development dependencies
  spec.add_development_dependency 'oj'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sidekiq'
end
