#typed: strict

module DVLA
  module Atlas
    class TestArtefactory
      extend T::Sig
      sig { returns(DVLA::Atlas::Artefacts) }
      def artefacts
        @artefacts ||= T.let(Artefacts.new, T.nilable(DVLA::Atlas::Artefacts))
      end
    end
  end
end
