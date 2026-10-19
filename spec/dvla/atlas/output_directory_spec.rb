require 'spec_helper'

RSpec.describe DVLA::Atlas::OutputDirectory do
  let(:frozen_time) { Time.new(2024, 6, 1, 12, 0, 0) }
  let(:expected_parent) { './test-logs/2024-06-01_12-00-00' }
  let(:scenario) { double(name: 'my scenario', location: double(file: 'features/test.feature', lines: [10])) }

  before do
    described_class.instance_variable_set(:@output_directory, nil)
    described_class.instance_variable_set(:@scenario_directory, nil)
    allow(Time).to receive(:now).and_return(frozen_time)
  end

  after do
    FileUtils.rm_rf('./test-logs')
    FileUtils.rm_f("/tmp/atlas-output-dir-#{Process.ppid}")
    FileUtils.rm_f("/tmp/atlas-output-dir-#{Process.ppid}.lock")
  end

  describe '.setup parallel safety' do
    it 'creates only one directory when called simultaneously from multiple processes' do
      directories = Parallel.map(10.times.to_a, in_processes: 10) do
        DVLA::Atlas::OutputDirectory.setup
      end

      expect(directories.uniq.length).to eq(1)
      expect(Dir.glob('./test-logs/*/').length).to eq(1)
    end
  end

  describe '.setup' do
    it 'creates a timestamped directory under test-logs' do
      described_class.setup
      expect(Dir.exist?(described_class.current)).to be true
      expect(described_class.current).to eq(expected_parent)
    end

    it 'returns the same directory when called a second time' do
      described_class.setup
      described_class.setup
      expect(described_class.current).to eq(expected_parent)
    end

    it 'writes the directory path to the sync file' do
      described_class.setup
      sync_file = "/tmp/atlas-output-dir-#{Process.ppid}"
      expect(File.read(sync_file)).to eq(expected_parent)
    end

    it 'reads the directory from the sync file on subsequent calls' do
      described_class.setup
      described_class.instance_variable_set(:@output_directory, nil)
      described_class.setup
      expect(described_class.current).to eq(expected_parent)
    end
  end

  describe '.current_scenario' do
    it 'is nil before scenario_directory is called' do
      expect(described_class.current_scenario).to be_nil
    end
  end

  describe '.scenario_directory' do
    it 'raises if setup has not been called' do
      expect { described_class.scenario_directory(scenario) }
        .to raise_error('Call DVLA::Atlas.setup_output_directory before using scenario_log_directory')
    end

    it 'creates a subdirectory nested under the parent directory' do
      described_class.setup
      described_class.scenario_directory(scenario)
      expect(Dir.exist?(described_class.current_scenario)).to be true
      expect(described_class.current_scenario).to start_with(expected_parent)
    end

    it 'includes the feature file and scenario name in the path' do
      described_class.setup
      described_class.scenario_directory(scenario)
      expect(described_class.current_scenario).to eq("#{expected_parent}/test.feature/my_scenario_[10]")
    end
  end

  describe 'DVLA::Atlas delegation' do
    it 'parent_directory returns OutputDirectory.current' do
      described_class.setup
      expect(DVLA::Atlas.parent_directory).to eq(described_class.current)
    end

    it 'scenario_directory returns OutputDirectory.current_scenario' do
      described_class.setup
      described_class.scenario_directory(scenario)
      expect(DVLA::Atlas.scenario_directory).to eq(described_class.current_scenario)
    end
  end
end
