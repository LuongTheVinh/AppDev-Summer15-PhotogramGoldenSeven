RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.order = :random
  config.warnings = false

  Kernel.srand config.seed

end

class RSpec::Core::Formatters::JsonFormatter
  def dump_summary(summary)
    total_points = summary.examples.map { |example| example.metadata[:points] }.sum
    score = summary.examples.select { |example| example.execution_result.status == :passed }
                            .map { |example| example.metadata[:points] }.sum

    @output_hash[:summary] = {
      :duration => summary.duration,
      :example_count => summary.example_count,
      :failure_count => summary.failure_count,
      :pending_count => summary.pending_count,
      :total_points => total_points,
      :score => score
    }
    @output_hash[:summary_line] = summary.totals_line + ", #{score}/#{total_points} points"
  end

private
  def format_example(example)
    {
      :description => example.description,
      :full_description => example.full_description,
      :status => example.execution_result.status.to_s,
      :points => example.metadata[:points],
      :file_path => example.metadata[:file_path],
      :line_number  => example.metadata[:line_number],
      :run_time => example.execution_result.run_time
    }
  end
end
