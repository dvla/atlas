require 'dvla/atlas'

RSpec.describe DVLA::Atlas do
  it 'returns a BaseWorld' do
    world = DVLA::Atlas.base_world
    expect(world).to be_a(DVLA::Atlas::TestArtefactory)
  end

  it 'creates a global method that returns the given object when make_artefacts_global is called' do
    expected_result = DVLA::Atlas::Artefacts.new
    DVLA::Atlas.make_artefacts_global(expected_result)
    expect(artefacts).to eq(expected_result)
  end

  it 'allows you to redefine what is returned by calling make_artefacts_global multiple times' do
    unexpected_result = DVLA::Atlas::Artefacts.new
    expected_result = DVLA::Atlas::Artefacts.new
    DVLA::Atlas.make_artefacts_global(unexpected_result)
    DVLA::Atlas.make_artefacts_global(expected_result)
    expect(artefacts).to eq(expected_result)
  end
end
