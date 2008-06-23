class PackedEnum
  include Enumerable

  attr_reader :identifiers
  attr_reader :attributes
  attr_reader :defaults

  def initialize(identifiers, attributes, value = nil)
    self.identifiers = identifiers
    self.attributes = attributes
    @map = value ? Bitmap.new(value, @width) : default_bitmap
  end

  def [](attribute)
    raise ArgumentError, "attribute #{attribute} not defined" unless index = @attributes.index(attribute)
    @reverse_identifiers[@map.get(index)]
  end

  def []=(attribute, value)
    raise ArgumentError, "attribute #{attribute} not defined" unless index = @attributes.index(attribute)
    raise ArgumentError, "identifier #{value} not defined" unless id = @identifiers[value]
    @map.set(index, id)
  end

  def ==(other)
    @map == other.map
  end

  def replace(other)
    @map = other.map.dup
  end
  alias :initialize_copy :replace

  def value
    @map.flags
  end

  def each
    @attributes.each { |a| yield [a, self[a]] }
  end
  
  protected
  attr_reader :map

  private

  def identifiers=(idents)
    @identifiers = {}
    idents.each_with_index do |ident, n|
      @identifiers[ident] = n
    end
    @width = (idents.size-1).to_s(2).size
    @reverse_identifiers = @identifiers.invert
  end

  def attributes=(attr)
    @defaults = attr.collect { |a| a.is_a?(Array) ? a.last : nil }
    @attributes = attr.collect { |a| a.is_a?(Array) ? a.first : a }
  end

  def default_bitmap
    m = Bitmap.new(0, @width)
    @defaults.each_with_index do |d, i|
      m.set(i, @identifiers[d] || 0)
    end
    m
  end
end
