packed_fields
============

Wrapper of ActiveRecord::Base.serialize 

example
-------

schema

    ActiveRecord::Schema.define(:version => 1) do
      create_table :mixins do |t|
        t.column :packed, :text
      end
    end

model

    class Mixin < ActiveRecord::Base
      packed :fields => [:foo, :bar]
    end

and using

    m = Mixins.new
    m.foo = 'blah'
    m.save #=> #<Mixin id: 1, packed: {:foo=>"blah"}>

