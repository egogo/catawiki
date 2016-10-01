require File.expand_path '../../test_helper.rb', __FILE__

describe Plato do
  let(:described_class) { Plato }
  let(:instance) { described_class.new }

  it 'exists' do
    instance.wont_be_nil
  end

end