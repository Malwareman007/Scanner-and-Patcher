$:.push File.expand_path("../lib", __FILE__)
require "angular_xss/version"

Gem::Specification.new do |s|
  s.name = 'angular_xss'
  s.version = AngularXss::VERSION
  s.authors = ["Malwareman007"]
  s.email = 'ojhakushagra73@gmail.com'
  s.homepage = 'https://github.com/Malwareman007/Open_Source_Web-Vulnerability-Scanner-and-Patcher/'
  s.summary = 'Patches rails_xss and Haml so AngularJS interpolations are auto-escaped in unsafe strings.'
  s.description = s.summary
  s.license = 'MIT'
  s.metadata = { 'rubygems_mfa_required' => 'true' }

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^spec/})
  s.require_paths = ["lib"]

  s.add_dependency('activesupport')
  s.add_dependency('haml', '>=3.1.5') # Haml below 3.1.5 does not escape HTML attributes by default. Do not use it!
end
