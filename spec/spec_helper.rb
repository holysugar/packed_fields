$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'active_record'
require 'packed_fields'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

def setup_db
  ActiveRecord::Migration.suppress_messages do
    ActiveRecord::Schema.define(:version => 1) do
      create_table :mixins do |t|
        t.column :packed, :text
      end

      create_table :second_mixins do |t|
        t.column :serialized, :text
      end
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

