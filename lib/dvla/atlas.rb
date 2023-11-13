# typed: strict

require 'dvla/atlas/artefacts'
require 'dvla/atlas/holder'
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
  end
end
