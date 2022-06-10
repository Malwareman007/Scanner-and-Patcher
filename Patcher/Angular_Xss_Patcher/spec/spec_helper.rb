require 'pathname'
require 'active_support/all'
require 'action_dispatch'
require 'action_view'

begin
  # Rails 3.2
  require 'rails'
rescue LoadError
  # Rails 4+
end

module Rails
  def self.env
    'test'.inquiry
  end
end

require 'haml'
require 'haml/template'

require 'angular_xss'


Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

TEMPLATE_ROOT = Pathname.new(__dir__).join('templates')


RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
