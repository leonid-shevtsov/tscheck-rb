require_relative 'lib/tscheck/version'

Gem::Specification.new do |spec|
  spec.name          = 'tscheck'
  spec.version       = TSCheck::VERSION
  spec.authors       = ['Leonid Shevtsov']
  spec.email         = ['leonid@shevtsov.me']

  spec.summary     = 'Validate Ruby hashes against TypeScript types.'
  spec.description = 'If you are making a Ruby API that is consumed by a TypeScript client, and you would like to ensure that the objects you return match the types you expect in TypeScript, this gem is for you.'
  spec.homepage      = 'https://github.com/leonid-shevtsov/tscheck-rb'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/leonid-shevtsov/tscheck-rb'
  spec.metadata['changelog_uri'] = 'https://github.com/leonid-shevtsov/tscheck-rb/blob/master/CHANGELOG.md'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|example)/}) }
  end
  spec.require_paths = ['lib']
end
