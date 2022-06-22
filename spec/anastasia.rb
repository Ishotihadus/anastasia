# frozen_string_literal: true

require 'yaml'

RSpec.describe Anastasia do
  it 'has a version number' do
    expect(Anastasia::VERSION).not_to be nil
  end

  let(:data) {YAML.load_file('spec/sample.yaml')}
  it 'converts a data structure' do
    expect(Anastasia.convert(data)).to eq(
      {
        'en' => {
          'test' => 'Test',
          'outer' => { 'inner' => { 'child' => 'Child' } },
          'dot' => { 'test' => { 'test' => 'DotTestTest' } },
          'lines' => 'This is test. This is test.',
          'cascaded' => {
            'context' => 'cascaded.context',
            'context_one' => 'cascaded.context_one',
            'context_other' => 'cascaded.context_other',
            'context_cascaded_context' => 'cascaded.context_cascaded_context'
          }
        },
        'ja' => {
          'test' => 'てすと',
          'outer' => { 'inner' => { 'child' => 'こども' } },
          'lines' => 'てすとですよ',
          'cascaded' => { 'context' => 'cascaded.context' }
        },
        'de' => { 'outer' => { 'inner' => { 'child' => 'Kind' } } }
      }
    )
  end
end
