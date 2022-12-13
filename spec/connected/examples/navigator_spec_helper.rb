# frozen_string_literal: true

require_relative "navigator/map"
require_relative "navigator/city"
require_relative "navigator/road"

@map = Map.new

NYC = City.new(name: "New York, NY", population: 8_400_000)
Boston = City.new(name: "Boston, MA", population: 700_000)
Cleveland = City.new(name: "Cleveland, OH", population: 400_000)
DC = City.new(name: "Washington, D.C.", population: 700_000)
Chicago = City.new(name: "Chicago, IL", population: 2_700_000)

@highway_90_w = Road.new(
  name: "Highway 90 W",
  start: Cleveland,
  finish: Chicago,
  length: 343,
  direction: :w,
  speedlimit: 65
)

@highway_90_e = Road.new(
  name: "Highway 90 E",
  start: Chicago,
  finish: Cleveland,
  length: 343,
  direction: :e,
  speedlimit: 65
)

@highway_76_w = Road.new(
  name: "Highway 76 W",
  start: DC,
  finish: Cleveland,
  length: 368,
  direction: :w,
  speedlimit: 60
)

@highway_76_e = Road.new(
  name: "Highway 76 E",
  start: Cleveland,
  finish: DC,
  length: 368,
  direction: :e,
  speedlimit: 60
)

@highway_80_w = Road.new(
  name: "Highway 80 W",
  start: NYC,
  finish: Cleveland,
  length: 479,
  direction: :w,
  speedlimit: 70
)

@highway_80_e = Road.new(
  name: "Highway 80 E",
  start: Cleveland,
  finish: NYC,
  length: 479,
  direction: :e,
  speedlimit: 70
)

@highway_95_n = Road.new(
  name: "Highway 95 N",
  start: DC,
  finish: NYC,
  length: 225,
  direction: :n,
  speedlimit: 65
)

@highway_95_s = Road.new(
  name: "Highway 95 S",
  start: NYC,
  finish: DC,
  length: 225,
  direction: :s,
  speedlimit: 65
)

@highway_2_w = Road.new(
  name: "Highway 2 W",
  start: Boston,
  finish: Cleveland,
  length: 640,
  direction: :w,
  speedlimit: 70
)

@highway_2_e = Road.new(
  name: "Highway 2 E",
  start: Cleveland,
  finish: Boston,
  length: 640,
  direction: :e,
  speedlimit: 70
)

@highway_84_n = Road.new(
  name: "Highway 84 N",
  start: NYC,
  finish: Boston,
  length: 215,
  direction: :n,
  speedlimit: 65
)

@highway_84_s = Road.new(
  name: "Highway 84 S",
  start: Boston,
  finish: NYC,
  length: 215,
  direction: :s,
  speedlimit: 65
)

[Boston, Chicago, Cleveland, DC, NYC].each { |c| @map.add_city(c) }
[
  @highway_2_e, @highway_2_w, @highway_76_e, @highway_76_w,
  @highway_80_e, @highway_80_w, @highway_84_n, @highway_84_s,
  @highway_90_e, @highway_90_w, @highway_95_n, @highway_95_s
].each { |h| @map.add_road(h) }
