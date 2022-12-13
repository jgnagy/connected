# frozen_string_literal: true

module Connected
  # Represents an indirect connection (combined edges) between two Vertices on a graph
  class Path
    def initialize(nodes, validate: true)
      validate_nodes(nodes) if validate

      @nodes = nodes
    end

    def connections
      links = nodes.dup
      links.size.downto(2).map do |i|
        links[-1 * i].connection_to(links[-1 * (i - 1)])
      end
    end

    def cost
      connections.map(&:metric).reduce(&:+)
    end

    def hops
      nodes.size - 1
    end

    def branch(node)
      return unless nodes.last.neighbors.include?(node) && !nodes.include?(node)

      self.class.new(nodes + [node], validate: false)
    end

    def nodes
      @nodes.dup
    end

    def open?
      connections.select(&:closed?).empty?
    end

    def from
      nodes.first
    end

    def to
      nodes.last
    end

    def to_s(separator = " -> ")
      nodes.map(&:name).join(separator)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def self.all(
      from:,
      to:,
      include_closed: false,
      debug: false,
      suboptimal: false,
      min_by: :cost,
      cache: {}
    )
      paths = []

      path_queue = from.neighbors.map { |n| new([from, n]) }

      until path_queue.empty?
        this_path = path_queue.pop
        next unless this_path.open? || include_closed

        unless suboptimal
          next if cache[this_path.to.name]&.<= this_path.send(min_by.to_sym)

          cache[this_path.to.name] = this_path.send(min_by.to_sym)
        end

        puts "Walking from #{this_path.nodes.map(&:name).join(" to ")}" if debug

        if this_path.to == to
          puts "Found destination with #{this_path.nodes.map(&:name).join(" to ")}" if debug
          paths << this_path
        else
          maxmeasure = paths.map(&min_by.to_sym).max

          this_path.to.neighbors.each do |n|
            new_path = this_path.branch(n)
            next unless new_path

            if paths.empty? || new_path.send(min_by.to_sym) <= maxmeasure || suboptimal
              path_queue.unshift(new_path)
            elsif debug
              puts "Skipping #{new_path.nodes.map(&:name).join(" to ")}"
            end
          end
        end
      end

      # Return the list of paths, sorted first by cost then by hops
      paths.sort_by { |p| min_by == :cost ? p.cost : p.hops }
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    def self.find(from:, to:, include_closed: false, min_by: :cost, cache: {})
      all(from:, to:, include_closed:, min_by:, cache:).first
    end

    private

    def validate_nodes(list)
      # Want to throw an exception if there are loops
      raise "Invalid Nodes list, duplicates found" unless list.size == list.uniq.size

      list.each_with_index do |item, index|
        break if index == list.size - 1

        # Each node should connect to the next (no leaves except the end of the list)
        raise "Invalid Nodes list, broken chain" unless item.neighbors.include?(list[index + 1])
      end

      true
    end
  end
end
