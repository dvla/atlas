require 'dvla/atlas'

BeforeAll do
  DVLA::Atlas::OutputDirectory.setup
end

Before do |scenario|
  DVLA::Atlas::OutputDirectory.scenario_directory(scenario)
end
