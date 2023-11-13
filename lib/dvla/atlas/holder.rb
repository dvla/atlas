#typed: strict

require 'singleton'

module DVLA
  module Atlas
    class Holder
      extend T::Sig
      include Singleton

      sig { returns(DVLA::Atlas::Artefacts) }
      attr_accessor :artefacts

      # The below is required by Sorbet. While the flow of the code within Atlas won't allow for :artefacts to be called
      # externally before something is assigned to it, Sorbet requires that it is initialized using T.let.
      sig { void }
      def initialize
        @artefacts = T.let(DVLA::Atlas::Artefacts.new, DVLA::Atlas::Artefacts)
      end
    end
  end
end
