module NCUA
  module CreditUnion
    class Record
      def initialize(attributes)
        @attributes = attributes
        @attributes.freeze
      end

      attr_reader :attributes

      def self.field(method_name, response_key=method_name, &munger)
        munger ||= lambda { |x| x }
        define_method(method_name) {
          if response_key.is_a? Symbol
            value = attributes[response_key]
          else
            value = attributes[response_key.to_s]
          end
          value && munger.call(value)
        }
      end

      def self.int_field(method_name, response_key=method_name)
        field(method_name, response_key, &:to_i)
      end

      def self.date_field(method_name, response_key=method_name)
        field(method_name, response_key) { |value|
          Date.parse(value)
        }
      end
    end
  end
end
