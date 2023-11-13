require 'dvla/atlas/test_artefactory'
require 'dvla/atlas/artefacts'

RSpec.describe DVLA::Atlas::TestArtefactory do
  let(:base_world) { DVLA::Atlas::TestArtefactory.new }

  it 'returns Artefacts when artefacts is called' do
    expect(base_world.artefacts).to be_a(DVLA::Atlas::Artefacts)
  end

  it 'returns the same instance of Artefacts when artefacts is called multiple times' do
    first_call = base_world.artefacts
    second_call = base_world.artefacts
    expect(first_call.object_id).to eq(second_call.object_id)
  end
end
