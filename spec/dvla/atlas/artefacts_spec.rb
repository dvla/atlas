require 'dvla/atlas/artefacts'

RSpec.describe DVLA::Atlas::Artefacts do
  let(:artefacts) { DVLA::Atlas::Artefacts.new }

  it 'creates a getter method from the parameter that has been passed into define_fields' do
    artefacts.define_fields('expected_method')
    expect(artefacts.methods).to include(:expected_method)
  end

  it 'creates a setter method from the parameter that has been passed into define_fields' do
    artefacts.define_fields('expected_method')
    expect(artefacts.methods).to include(:'expected_method=')
  end

  it 'creates a getter method for the history of the parameter that has been passed into define_fields' do
    artefacts.define_fields('expected_method')
    expect(artefacts.methods).to include(:expected_method_history)
  end

  it 'returns nil from the created getter when no value was initially assigned' do
    artefacts.define_fields('new_method')
    expect(artefacts.new_method).to be_nil
  end

  it 'returns an empty array from the created history getter when no value was initially assigned' do
    artefacts.define_fields('new_method')
    expect(artefacts.new_method_history).to eq([])
  end

  it 'sets the value when the generated setter method is called' do
    artefacts.define_fields('new_method')
    artefacts.new_method = 123
    expect(artefacts.new_method).to eq(123)
  end

  it 'does not add the initial nil value to the history when the generated setter method is called' do
    artefacts.define_fields('new_method')
    artefacts.new_method = 123
    expect(artefacts.new_method_history).to eq([])
  end

  it 'adds the current value to the history when the generated setter method is called multiple times' do
    artefacts.define_fields('new_method')
    artefacts.new_method = 123
    artefacts.new_method = 456
    artefacts.new_method = 789

    history = artefacts.new_method_history
    expect(history.length).to eq(2)
    expect(history[0]).to eq(123)
    expect(history[1]).to eq(456)
  end

  it 'creates a getter method from the keyword parameter that has been passed into define_fields' do
    artefacts.define_fields(expected_method: 123)
    expect(artefacts.methods).to include(:expected_method)
  end

  it 'creates a setter method from the keyword parameter that has been passed into define_fields' do
    artefacts.define_fields(expected_method: 123)
    expect(artefacts.methods).to include(:'expected_method=')
  end

  it 'creates a getter method for the history of the keyword parameter that has been passed into define_fields' do
    artefacts.define_fields(expected_method: 123)
    expect(artefacts.methods).to include(:expected_method_history)
  end

  it 'returns the value that was passed in with the keyword from the created getter' do
    artefacts.define_fields(new_method: 123)
    expect(artefacts.new_method).to eq(123)
  end

  it 'returns the result of a proc passed in with the keyword from the created getter' do
    proc = Proc.new { |x| x + 1 }
    artefacts.define_fields(new_method: -> { proc })
    expect(artefacts.new_method.(1)).to eq(2)
  end

  it 'returns an empty array from the created history getter when created from a keyword argument' do
    artefacts.define_fields(new_method: 123)
    expect(artefacts.new_method_history).to eq([])
  end

  it 'sets the value when the generated setter method is called' do
    artefacts.define_fields(new_method: 123)
    artefacts.new_method = 456
    expect(artefacts.new_method).to eq(456)
  end

  it 'adds the current value to the history when the generated setter method is called multiple times' do
    artefacts.define_fields(new_method: 123)
    artefacts.new_method = 456
    artefacts.new_method = 789

    history = artefacts.new_method_history
    expect(history.length).to eq(2)
    expect(history[0]).to eq(123)
    expect(history[1]).to eq(456)
  end

  it 'creates a getter method from both types of parameters that are passed into define_fields' do
    artefacts.define_fields('first_expected_method', second_expected_method: 123)
    expect(artefacts.methods).to include(:first_expected_method)
    expect(artefacts.methods).to include(:second_expected_method)
  end

  it 'creates a setter method from both types of parameters that are passed into define_fields' do
    artefacts.define_fields('first_expected_method', second_expected_method: 123)
    expect(artefacts.methods).to include(:'first_expected_method=')
    expect(artefacts.methods).to include(:'second_expected_method=')
  end

  it 'sets the correct history when multiple variables have been defined' do
    artefacts.define_fields('first_expected_method', second_expected_method: 123)
    artefacts.first_expected_method = 'abc'
    artefacts.first_expected_method = 'def'
    artefacts.second_expected_method = 456

    expect(artefacts.first_expected_method_history).to eq(%w[abc])
    expect(artefacts.second_expected_method_history).to eq([123])
  end
end
