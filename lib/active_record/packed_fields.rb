module ActiveRecord
  module PackedFields

    module ClassMethods
      def packed(options)
        column = options[:column] || :packed
        fields = options[:fields]
        validation = options[:validation]

        serialize column, Hash
        

        fields.each do |field|
          define_method(field) { 
            hash = read_attribute(column)
            if hash
              hash[field]
            end
          }
          define_method("#{field}="){|value|
            hash = read_attribute(column)
            if hash
              hash[field] = value
            else
              write_attribute(column, { field => value })
            end
          }

          validates field, validation.dup if validation
        end
      end

    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
