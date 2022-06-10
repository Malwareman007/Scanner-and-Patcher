require 'spec_helper'

describe ActiveSupport::SafeBuffer do

  it 'still allows concatting nil' do
    expect { subject << nil }.to_not raise_error
  end

end
