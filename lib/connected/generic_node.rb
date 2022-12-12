# frozen_string_literal: true

module Connected
  # Generic example node
  class GenericNode
    include Vertex

    attr_reader :name
    attr_accessor :connections

    def initialize(name)
      @name = name
      @connections = []
    end

    def connects_to(other, metric: 1, state: :open, directed: false)
      # Only one connection between nodes
      return true if neighbors.include?(other)

      connections << GenericConnection.new(
        from: self, to: other, metric:, state: state.to_sym
      )

      other.connects_to(self, metric:, state:) unless directed
    end

    def disconnect_from(other, directed: false)
      connections.delete_if { |c| c.to == other }
      other.disconnect_from(self) if other.neighbors.include?(self) && !directed
    end
  end
end
