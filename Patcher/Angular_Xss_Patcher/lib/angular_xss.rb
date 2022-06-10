#"string".respond_to?(:html_safe?) or raise "No rails_xss implementation present"

require 'angular_xss/escaper'
require 'angular_xss/safe_buffer'
require 'angular_xss/erb'
require 'angular_xss/haml'
require 'angular_xss/action_view'
