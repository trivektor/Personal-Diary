describe 'Story' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Story entity' do
    Story.entity_description.name.should == 'Story'
  end
end
