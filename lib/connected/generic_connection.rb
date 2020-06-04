# frozen_string_literal: true

module Connected
  # A generic implementation of an Edge
  class GenericConnection
    include Edge

    attr_reader :from, :to, :metric, :state

    def initialize(from:, to:, metric: 1, state: :open)
      validate_from(from)
      validate_to(to)
      validate_metric(metric)
      validate_state(state)

      raise 'Invalid Connection from and to same Vertex' if from == to

      @from = from
      @to = to
      @metric = metric
      @state = state
    end

    def metric=(value)
      validate_metric(value)
      @metric = value
    end

    def state=(setting)
      validate_state(setting)
      @state = setting
    end

    private

    def validate_from(node)
      raise 'Invalid from Node' unless node.is_a?(Vertex)
    end

    def validate_to(node)
      raise 'Invalid to Node' unless node.is_a?(Vertex)
    end

    def validate_metric(num)
      raise 'Invalid metric' unless num.is_a?(Numeric) && num.positive?
    end

    def validate_state(value)
      raise 'Invalid state' unless %i[open closed].include?(value)
    end
  end
end
