require 'active_record/packed_fields'
ActiveRecord::Base.class_eval { include ActiveRecord::PackedFields }
