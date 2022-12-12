# frozen_string_literal: true

module Connected
  # Vertices are based on a mixin
  module Vertex
    def connections
      # Expect classes to describe how to find connections
      raise "#connections() MUST be implemented on #{self.class.name}"
    end

    def edges
      connections
    end

    def graph
      @graph || subtree
    end

    # A shortcut for retrieving this node's neighbors
    def neighbors
      connections.map(&:to).uniq
    end

    # The neighborhood of a Vertex is a Graph of all neighbors and any connections
    # they have to each other.
    # @see https://en.wikipedia.org/wiki/Neighbourhood_(graph_theory)
    def neighborhood(closed: false)
      vertices = neighbors
      vertices << self if closed
      n_edges = vertices.map(&:connections).flatten.uniq.select { |c| vertices.include?(c.to) }
      GenericGraph.new(vertices:, edges: n_edges)
    end

    # Retrieves the Connection object responsible for connecting to a Node
    def connection_to(other)
      connections.select { |c| c.to == other }.min_by(&:metric)
    end

    def eccentricity
      reachable_vertices.map do |r|
        self == r ? nil : Path.find(from: self, to: r).cost
      end.compact.max
    end

    def reaches?(other)
      reachable_vertices.include?(other)
    end

    def reachable_from?(other)
      other.reachable_vertices.include?(self)
    end

    def reachable_vertices
      rverts = neighbors + [self]

      queue = (neighbors.map(&:neighbors).flatten.uniq - neighbors)

      until queue.empty?
        this_vert = queue.pop
        next if this_vert == self

        rverts << this_vert
        this_vert.neighbors.each do |v|
          queue << v unless rverts.include?(v)
        end
      end

      rverts.uniq
    end

    # A subtree is a subgraph including all edges and vertices reachable from a vertex
    def subtree
      GenericGraph.new(vertices: reachable_vertices)
    end
  end
end
