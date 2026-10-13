# typed: strict

require 'dvla/atlas/artefacts'
require 'dvla/atlas/holder'
require 'dvla/atlas/output_directory'
require 'dvla/atlas/test_artefactory'
require 'sorbet-runtime'

module DVLA
  module Atlas
    extend T::Sig

    sig { returns(DVLA::Atlas::TestArtefactory) }
    def self.base_world
      TestArtefactory.new
    end

    sig { params(artefacts: DVLA::Atlas::Artefacts).void }
    def self.make_artefacts_global(artefacts)
      DVLA::Atlas::Holder.instance.artefacts = artefacts
      Object.send(:define_method, :artefacts) { DVLA::Atlas::Holder.instance.artefacts }
    end

    sig { returns(String) }
    def self.setup_output_directory
      DVLA::Atlas::OutputDirectory.setup
    end

    sig { params(scenario: T.untyped).returns(String) }
    def self.scenario_log_directory(scenario)
      DVLA::Atlas::OutputDirectory.scenario_directory(scenario)
    end

    sig { returns(T.nilable(String)) }
    def self.output_dir
      DVLA::Atlas::OutputDirectory.current_scenario || DVLA::Atlas::OutputDirectory.current
    end
  end
end
