# frozen_string_literal: true

RSpec.describe Connected::Path do
  subject do
    described_class.all(from: nodes["a"], to: nodes["e"])
  end

  let(:expected_paths) do
    [
      "a -> c -> f -> e",
      "a -> f -> e"
    ]
  end
  let(:graph_with_suboptimal_connections) do
    described_class.all(from: nodes["a"], to: nodes["e"], suboptimal: true)
  end
  let(:graph_with_closed_connection) do
    described_class.all(from: nodes["a"], to: nodes["f"])
  end
  let(:graph_with_allowed_closed_connection) do
    described_class.all(from: nodes["a"], to: nodes["f"], include_closed: true)
  end
  let(:lowest_cost) do
    described_class.find(from: nodes["a"], to: nodes["e"])
  end
  let(:lowest_directed_cost) do
    described_class.find(from: directed_nodes["a"], to: directed_nodes["e"])
  end

  let(:expected_paths_with_closed) do
    [
      "a -> e -> f",
      "a -> c -> f",
      "a -> f"
    ]
  end

  let(:expected_paths_without_closed) do
    [
      "a -> c -> f",
      "a -> f"
    ]
  end

  let(:nodes) do
    list = {}

    ("a".."f").each { |l| list[l] = Connected::GenericNode.new(l) }

    list["a"].connects_to list["b"], metric: 7
    list["a"].connects_to list["c"], metric: 9
    list["a"].connects_to list["e"], state: :closed
    list["a"].connects_to list["f"], metric: 14
    list["b"].connects_to list["c"], metric: 10
    list["b"].connects_to list["d"], metric: 15
    list["c"].connects_to list["d"], metric: 11
    list["c"].connects_to list["f"], metric: 2
    list["d"].connects_to list["e"], metric: 6
    list["e"].connects_to list["f"], metric: 9

    list
  end

  let(:directed_nodes) do
    list = {}

    ("a".."f").each { |l| list[l] = Connected::GenericNode.new(l) }

    list["a"].connects_to list["b"], metric: 7, directed: true
    list["a"].connects_to list["c"], metric: 9, directed: true
    list["a"].connects_to list["f"], metric: 14, directed: true
    list["b"].connects_to list["c"], metric: 10, directed: true
    list["b"].connects_to list["d"], metric: 15, directed: true
    list["c"].connects_to list["d"], metric: 11, directed: true
    list["c"].connects_to list["f"], metric: 2, directed: true
    list["d"].connects_to list["e"], metric: 6, directed: true
    list["e"].connects_to list["f"], metric: 9, directed: true

    list
  end

  it "finds all paths" do
    expect(subject).not_to be_nil
    expect(subject).not_to be_empty
    expect(subject.size).to eq(expected_paths.size)
    expect(subject.map(&:to_s)).to eq(expected_paths)
  end

  it "finds all paths including suboptimal paths" do
    expect(graph_with_suboptimal_connections).not_to be_nil
    expect(graph_with_suboptimal_connections).not_to be_empty
    expect(graph_with_suboptimal_connections.size).to eq(10)
    expect(graph_with_suboptimal_connections.first.to_s).to eq(expected_paths.first)
  end

  it "finds the lowest cost path" do
    expect(lowest_cost.to_s).to eq("a -> c -> f -> e")
  end

  it "finds the lowest cost path of a directed graph" do
    expect(lowest_directed_cost.to_s).to eq("a -> c -> d -> e")
  end

  it "can be used to find the path with the least hops" do
    expect(subject.min_by(&:hops).to_s).to eq("a -> f -> e")
  end

  it "takes into account closed connections" do
    expect(graph_with_closed_connection.size).to eq(
      expected_paths_without_closed.size
    )
    expect(graph_with_closed_connection.map(&:to_s)).to eq(
      expected_paths_without_closed
    )
  end

  it "allows including closed paths" do
    expect(graph_with_allowed_closed_connection.size).to eq(
      expected_paths_with_closed.size
    )
    expect(graph_with_allowed_closed_connection.map(&:to_s)).to eq(
      expected_paths_with_closed
    )
  end
end
