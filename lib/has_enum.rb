module HasEnum

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def has_enum(name, options={})
      options.symbolize_keys!
      options.assert_valid_keys(:column, :identifiers, :attributes)
      field_attr_name = "#{name}_column"
      class_inheritable_accessor field_attr_name.to_sym
      column_name = options[:column] || "#{name}_map"
      self.send("#{field_attr_name}=".to_sym, column_name)
      identifiers = options[:identifiers] || []
      attributes = options[:attributes] || []


      enum_class = Class.new(PackedEnum) do
        class_eval <<-EOF
          def initialize(value=nil)
            super(#{identifiers.inspect}, #{attributes.inspect}, value)
          end
        EOF
      end
      enum_class_name = name.to_s.classify
      const_set(enum_class_name, enum_class)

      composed_of name.to_sym, :class_name => "#{self.class_name}::#{enum_class_name}", :mapping => [column_name, "value"]
    end

  end

end
