# frozen_string_literal: true

module Connected
  # Used to mixin a direct connection between two Vertices (an Edge) on a graph
  module Edge
    include Comparable

    def from
      # Expect classes to describe the "from" Vertex
      raise "#from() MUST be implemented on #{self.class.name}"
    end

    def to
      # Expect classes to describe the "to" Vertex
      raise "#to() MUST be implemented on #{self.class.name}"
    end

    # This should almost certainly be overridden
    def metric
      1
    end

    def closed?
      unless respond_to?(:state)
        # Expect classes to describe how to determine if they're closed
        raise "#state() or #closed? MUST be implemented on #{self.class.name}"
      end

      state.to_s == :closed.to_s
    end

    def open?
      unless respond_to?(:state)
        # Expect classes to describe how to determine if they're open
        raise "#state() or #open? MUST be implemented on #{self.class.name}"
      end

      state.to_s == :open.to_s
    end

    def <=>(other)
      if (open? && other.open?) || (closed? && other.closed?)
        metric <=> other.metric
      elsif open?
        -1
      elsif other.open?
        1
      end
    end
  end
end
