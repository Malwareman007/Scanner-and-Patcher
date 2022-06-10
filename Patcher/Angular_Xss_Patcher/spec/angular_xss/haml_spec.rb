require 'spec_helper'

describe 'Angular XSS prevention in Haml', :type => :view do

  it_should_behave_like 'engine preventing Angular XSS', :partial => 'test_haml'

end
