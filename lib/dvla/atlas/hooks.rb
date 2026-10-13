require 'dvla/atlas'

BeforeAll do
  DVLA::Atlas.setup_output_directory
end

Before do |scenario|
  DVLA::Atlas.scenario_log_directory(scenario)
end
