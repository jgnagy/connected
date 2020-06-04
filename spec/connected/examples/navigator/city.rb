# frozen_string_literal: true

class City
  include Connected::Vertex

  attr_accessor :name, :population, :map

  def initialize(name:, population: nil)
    @name = name
    @population = population
    @map = nil
  end

  def connections
    map.roads.select { |r| r.from == self }
  end
end
