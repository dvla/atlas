require 'dvla/atlas/holder'

describe DVLA::Atlas::Holder do
  let(:holder) { DVLA::Atlas::Holder.instance }
  before(:each) do
    holder.artefacts = nil
  end

  it 'allows values to be written to artefacts that can be accessed via other instances' do
    holder.artefacts = DVLA::Atlas::Artefacts.new

    expect(DVLA::Atlas::Holder.instance.artefacts).to eq(holder.artefacts)
  end
end
