# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)
YARD::Rake::YardocTask.new do |y|
  y.options = [
    "--markup", "markdown"
  ]
end

task default: %i[spec rubocop yard]
