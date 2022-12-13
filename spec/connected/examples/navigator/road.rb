# frozen_string_literal: true

class Road
  include Connected::Edge

  attr_accessor :map
  attr_reader :name, :speedlimit, :state, :direction

  def initialize(name:, start:, finish:, length:, direction:, speedlimit: 35)
    validate_name(name)
    validate_ends(start, finish)
    validate_length(length)
    validate_direction(direction)
    validate_speed(speedlimit)

    @name = name
    @start = start
    @finish = finish
    @length = length
    @direction = direction
    @speedlimit = speedlimit
    @state = :open
    @map = nil
  end

  def from
    @start
  end

  def to
    @finish
  end

  def metric
    # Add a penalty for construction and traffic
    (@length.to_f / speedlimit) * (state == :construction ? 2 : 1) * (state == :traffic ? 1.5 : 1)
  end

  def name=(value)
    validate_name(value)
    @name = value
  end

  def state=(setting)
    validate_state(setting)
    @state = setting
  end

  private

  def validate_direction(dir)
    raise "Invalid direction" unless %i[n s e w].include?(dir)
  end

  def validate_ends(a, b)
    raise "Source and destination can not be the same" if a == b

    validate_end a
    validate_end b
  end

  def validate_end(object)
    raise "Invalid road ending" unless object.is_a?(Connected::Vertex)
  end

  def validate_length(num)
    raise "Invalid length" unless num.is_a?(Numeric) && num.positive?
  end

  def validate_name(name)
    raise "Invalid name" unless name.is_a?(String)
  end

  def validate_speed(num)
    raise "Invalid speedlimit" unless num.is_a?(Numeric) && (1..1000).include?(num)
  end

  def validate_state(value)
    raise "Invalid state" unless %i[open construction closed traffic].include?(value)
  end
end
