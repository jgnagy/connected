# frozen_string_literal: true

module Connected
  # A collection of related vertices and edges
  module Graph
    include Comparable

    def initialize(vertices:, edges: nil)
      @vertices = vertices
      @edges = edges
    end

    def adjacency_matrix
      rows = @vertices.map do |i|
        @vertices.map do |j|
          i == j || i.neighbors.include?(j) ? 1 : 0
        end.to_a
      end.to_a
      Matrix.rows(rows)
    end

    # A "complete graph" is one where all vertices connect to all others
    def complete?
      density == 1 || vertices.size == 1
    end

    # The density is the ratio to a complete graph of the same number of vertices
    def density
      return 0 if edges.size.zero? # otherwise we'd divide by 0!

      # Assumes an directed graph for now, therefore e / n(n -1)
      # is the ratio of edges (e) to edges in a complete graph
      edges.size.to_f / ((vertices.size * (vertices.size - 1)))
    end

    # The diameter of a graph is the longest of all shortest paths between all vertices on a graph
    def diameter
      longest = nil
      vertices.each do |v|
        dist = v.eccentricity
        longest = dist if longest.nil? || dist > longest
      end

      longest
    end

    def edges
      @edges || vertices.map(&:connections).flatten.uniq
    end

    def length
      edges.size
    end

    def radius
      shortest = nil
      vertices.each do |v|
        ecc = v.eccentricity
        shortest = ecc if shortest.nil? || ecc < shortest
      end

      shortest
    end

    def vertices
      @vertices
    end

    def <=>(other)
      vertices == other.vertices && edges == other.edges
    end
  end
end
