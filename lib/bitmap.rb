class Bitmap
  attr_accessor :width
  attr_accessor :mask
  attr_accessor :flags

  def initialize(value, width=1)
    self.flags = value
    self.width = width
    self.mask = (1<<width)-1
  end

  def get(pos)
    r = flags & (mask<<(pos*width))
    r >> (pos*width)
  end

  def set(pos, setting)
    r = flags & ~(mask<<(pos*width))
    @flags = r | (setting<<(pos*width))
    setting
  end

  def ==(other)
    self.flags == other.flags
  end
end

