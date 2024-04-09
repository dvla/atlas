# frozen_string_literal: true

require_relative 'lib/dvla/atlas/version'

Gem::Specification.new do |spec|
  spec.name = 'dvla-atlas'
  spec.version = DVLA::Atlas::VERSION
  spec.authors = ['Driver and Vehicle Licensing Agency (DVLA)', 'George Bell']
  spec.email = ['george.bell.contractor@dvla.gov.uk']

  spec.summary = 'A lightweight gem that encapsulates the ability to define a common set of properties for a test suite, leveraging the World functionality built into Cucumber'
  spec.required_ruby_version = Gem::Requirement.new('>= 3')
  spec.homepage = 'https://github.com/dvla/atlas'

  spec.license = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'sorbet-runtime', '~> 0.5'

  spec.add_development_dependency 'bundler-audit', '~> 0.9'
  spec.add_development_dependency 'dvla-lint', '~> 1.7'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'sorbet', '~> 0.5'
  spec.add_development_dependency 'tapioca', '~> 0.10'
end
