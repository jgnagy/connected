# frozen_string_literal: true

require_relative "navigator_spec_helper"

RSpec.describe "Navigator Example" do
  it "finds the fastest route from Chicago to Boston" do
    expect(
      Connected::Path.find(from: Chicago, to: Boston).to_s
    ).to eq("Chicago, IL -> Cleveland, OH -> Boston, MA")
  end

  context "with construction" do
    it "finds the fastest route from Chicago to Boston" do
      Cleveland.connection_to(Boston).state = :construction
      expect(
        Connected::Path.find(from: Chicago, to: Boston).to_s
      ).to eq("Chicago, IL -> Cleveland, OH -> New York, NY -> Boston, MA")
    end
  end
end
