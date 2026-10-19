require 'spec_helper'

RSpec.describe DVLA::Atlas do
  it 'returns a BaseWorld' do
    world = DVLA::Atlas.base_world
    expect(world).to be_a(DVLA::Atlas::TestArtefactory)
  end

  describe '.make_artefacts_global' do
    it 'creates a global method that returns the given object' do
      expected_result = DVLA::Atlas::Artefacts.new
      DVLA::Atlas.make_artefacts_global(expected_result)
      expect(artefacts).to eq(expected_result)
    end

    it 'returns the last assigned value when called multiple times' do
      DVLA::Atlas.make_artefacts_global(DVLA::Atlas::Artefacts.new)
      expected_result = DVLA::Atlas::Artefacts.new
      DVLA::Atlas.make_artefacts_global(expected_result)
      expect(artefacts).to eq(expected_result)
    end
  end
end
