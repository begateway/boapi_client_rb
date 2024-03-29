# frozen_string_literal: true

require_relative 'lib/boapi/version'

Gem::Specification.new do |spec|
  spec.name = 'boapi'
  spec.version = Boapi::VERSION
  spec.authors = ['eComCharge']
  spec.email = ['info@ecomcharge.com']

  spec.summary = 'Ruby client for boapi service.'
  spec.description = 'Ruby client for boapi service.'
  spec.homepage = 'https://www.begateway.com'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/begateway/boapi_client_rb'
  spec.metadata['changelog_uri'] = 'https://github.com/begateway/boapi_client_rb/blob/master/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'faraday', '> 0.7.6', '< 1.0'
  spec.add_dependency 'faraday_middleware', '> 0.1', '< 1.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.19.0'
  spec.add_development_dependency 'webmock', '~> 3.18.1'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
