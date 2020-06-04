# frozen_string_literal: true

class Map
  def initialize
    @cities = []
    @roads = []
  end

  def cities
    @cities.dup
  end

  def roads
    @roads.dup
  end

  def add_city(city)
    return false if @cities.include?(city)

    @cities << city
    city.map = self
  end

  def add_road(road)
    return false if @roads.include?(road)

    @roads << road
    road.map = self
  end
end
