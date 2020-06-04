# frozen_string_literal: true

module Connected
  # Vertices are based on a mixin
  module Vertex
    def connections
      # Expect classes to describe how to find connections
      raise "#connections() MUST be implemented on #{self.class.name}"
    end

    # A shortcut for retrieving this node's neighbors
    def neighbors
      connections.map(&:to).uniq
    end

    # Retrieves the Connection object responsible for connecting to a Node
    def connection_to(other)
      connections.select { |c| c.to == other }.min_by(&:metric)
    end
  end
end
