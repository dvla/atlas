require 'simplecov'
require 'simplecov-console'
require 'simplecov_json_formatter'
require 'parallel'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::JSONFormatter, SimpleCov::Formatter::Console])
SimpleCov.minimum_coverage 80
SimpleCov.start do
  track_files 'lib/**/*.rb'
  add_filter ['spec/', 'version.rb', 'hooks.rb']
end

require 'dvla/atlas'
