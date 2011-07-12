require 'spec_helper'
require 'packed_fields'

class ModelWithPacked < ActiveRecord::Base
  set_table_name 'mixins'

  packed :fields => [:foo, :bar]
end

class CanSetColumnName < ActiveRecord::Base
  set_table_name 'second_mixins'

  packed :column => :serialized, :fields => [:foo, :bar]
end


describe ModelWithPacked do
  before(:all) { setup_db }
  after(:all) { teardown_db }

  let(:model) { ModelWithPacked.new }

  describe "setting foo 'blah' and bar 1" do
    subject {
      model.foo = "blah"
      model.bar = 1
      model.save
      model.reload
    }
    its(:foo) { should eq 'blah' }
    its(:bar) { should eq 1 }

    it "packed[:foo] should == 'blah'" do
      subject.packed[:foo].should eq 'blah'
    end
  end

  it "set foo and save changes packed" do
    expect { model.foo = "blah" ; model.save }.to change { model.packed }
  end


end

describe CanSetColumnName do
  before(:all) { setup_db }
  after(:all) { teardown_db }
  let(:model) { CanSetColumnName.new }

  it "saving packed changes given column name" do
    expect { model.foo = "blah" ; model.save }.to change { model.serialized }
  end

end

