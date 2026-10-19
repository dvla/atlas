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


      sig { returns(String) }
      def self.parallel_safe_setup
        sync_file = "/tmp/atlas-output-dir-#{Process.ppid}"

        File.open("#{sync_file}.lock", File::RDWR | File::CREAT, 0o644) do |lock|
          lock.flock(File::LOCK_EX)
          return File.read(sync_file) if File.exist?(sync_file)

          directory = "./test-logs/#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}"
          FileUtils.mkdir_p(directory)
          File.write(sync_file, directory)
          directory
        end
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
