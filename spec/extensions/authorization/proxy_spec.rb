require File.expand_path(File.dirname(__FILE__) + '/../../simple_spec_helper')

class TestAbility
  def initialize(*args)
  end
end

describe Lolita::Extensions::Authorization::Proxy do 
  let(:klass){ Lolita::Extensions::Authorization::Proxy }
  let(:proxy){ klass.new(Object.new,{}) }
  around(:each) do |example|
    Lolita.ability_class = TestAbility
    example.run
    Lolita.ability_class = nil
  end
  
  it "should create new proxy" do
    expect do
      klass.new(Object.new,{})
    end.not_to raise_error
  end

  it "should have #can?" do
    proxy.respond_to?(:can?).should be_truthy
  end
  
  it "should have #cannot?" do
    proxy.respond_to?(:cannot?).should be_truthy
  end

  it "should have #authorize!" do
    proxy.respond_to?(:authorize!).should be_truthy
  end

  it "should have #current_ability" do
    proxy.respond_to?(:current_ability).should be_truthy
  end

  describe 'Connecting adapter' do
    context 'default adapter' do
      it "should create when authorization is not specified or is 'Default'" do
        proxy.adapter.should be_a(Lolita::Extensions::Authorization::DefaultAdapter)
        Lolita.authorization = 'Default'
        proxy.adapter.should be_a(Lolita::Extensions::Authorization::DefaultAdapter)
      end
    end
    context 'devise adapter' do
      let(:proxy){ 
        mock_class = Object.new
        mock_class.class_eval{include Lolita::Extensions}
        klass.new(mock_class,{}) 
      }
      it "should create when Lolita.authentication is specified" do
        Lolita.authorization = 'CanCan'
        proxy.adapter.should be_a(Lolita::Extensions::Authorization::CanCanAdapter)
        Lolita.authorization = nil
      end
    end
  end
end
