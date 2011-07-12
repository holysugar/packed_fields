module ActiveRecord
  module PackedFields

    module ClassMethods
      def packed(options)
        column = options[:column] || :packed
        fields = options[:fields]

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
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
