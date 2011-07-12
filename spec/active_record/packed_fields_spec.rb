require 'spec_helper'
require 'packed_fields'

class ModelWithPacked < ActiveRecord::Base
  set_table_name 'mixins'

  packed :fields => [:foo, :bar], :validation => { :length => { :within => 0..5, :allow_nil => true } }
end

class CanSetColumnName < ActiveRecord::Base
  set_table_name 'second_mixins'

  packed :column => :serialized, :fields => [:foo, :bar]
end


describe ModelWithPacked do
  before(:all) { setup_db }
  after(:all) { teardown_db }

  let(:model) { ModelWithPacked.new }

  describe "blank model" do

    its(:foo) { should be_nil }
    its(:bar) { should be_nil }
    it { should be_valid }

  end

  describe "setting foo 'blah'" do
    subject {
      model.foo = "blah"
      model.save
      model.reload
    }
    its(:foo) { should eq 'blah' }

    it "packed[:foo] should == 'blah'" do
      subject.packed[:foo].should eq 'blah'
    end
  end

  it "set foo and save changes packed" do
    expect { model.foo = "blah" ; model.save }.to change { model.packed }
  end

  describe "validation" do
    describe "for example, validates length and bar is too long string" do
      subject { model.bar = 'toolongstring'; model.valid?; model }
      it { should be_invalid }
      it "errors[:bar] exists" do
        subject.errors[:bar].should be
      end
    end
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

