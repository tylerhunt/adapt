Gem::Specification.new do |gem|
  gem.name    = 'adapt'
  gem.version = '0.0.1'
  gem.summary = 'An interface library for the PayPal Adaptive Payments service.'
  gem.homepage = %q{http://github.com/tylerhunt/adapt}
  gem.authors = ['Tyler Hunt']

  gem.files = Dir['LICENSE', 'lib/**/*']

  gem.add_dependency 'activemodel', '3.0.0'
  gem.add_dependency 'patron', '0.4.6'
  gem.add_dependency 'tzinfo', '0.3.22'

  gem.add_development_dependency 'remarkable_activemodel', '4.0.0.alpha4'
  gem.add_development_dependency 'rspec', '2.0.0.beta.15'
  gem.add_development_dependency 'sinatra', '1.0'
  gem.add_development_dependency 'vcr', '1.0.2'
  gem.add_development_dependency 'webmock', '1.3.0'
end
