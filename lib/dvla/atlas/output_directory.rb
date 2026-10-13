# typed: strict

require 'fileutils'
require 'sorbet-runtime'

module DVLA
  module Atlas
    class OutputDirectory
      extend T::Sig

      sig { returns(T.nilable(String)) }
      def self.current
        @output_directory
      end

      sig { returns(T.nilable(String)) }
      def self.current_scenario
        @scenario_directory
      end

      sig { returns(String) }
      def self.setup
        @output_directory = T.let(parallel_safe_setup, T.nilable(String))
      end

      private

      sig { returns(String) }
      def self.parallel_safe_setup
        sync_file = "/tmp/atlas-output-dir-#{Process.ppid}"

        if first_process?
          directory = "./test-logs/#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}"
          FileUtils.mkdir_p(directory)
          File.write(sync_file, directory)
          directory
        else
          sleep 0.1 until File.exist?(sync_file)
          File.read(sync_file)
        end
      end

      sig { returns(T::Boolean) }
      def self.first_process?
        return true unless ENV['TEST_ENV_NUMBER']

        require 'parallel_tests'
        ParallelTests.first_process?
      end

      sig { params(scenario: T.untyped).returns(String) }
      def self.scenario_directory(scenario)
        raise 'Call DVLA::Atlas.setup_output_directory before using scenario_log_directory' if @output_directory.nil?

        feature_file = scenario.location.file.split('/').last
        scenario_name = "#{scenario.name.gsub(/[^\w]/, '_')}_#{scenario.location.lines}"
        @scenario_directory = T.let("#{@output_directory}/#{feature_file}/#{scenario_name}", T.nilable(String))
        FileUtils.mkdir_p(@scenario_directory)
        @scenario_directory
      end
    end
  end
end
