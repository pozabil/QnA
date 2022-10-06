require 'rails_helper'

RSpec.describe Link, type: :model do
  let (:correct_urls) { [
    'google.com',
    'https://google.com',
    '  http://www.google.com  ',
    'hTTp://www.Google.com/99ik?#0/s?fas=42/s'
  ] }
  let (:wrong_urls) { [
    'googlecom',
    'http://wwwgooglecom',
    'http://wwwgoogle...com',
    'http://wwwgoogle./com',
    'http://wwwgoogle.#com',
    'http://ww wgoogl e.com'
  ] }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '.format_url' do
    it 'returns correct formatted url string' do
      expect(described_class.format_url('  www.google.com  ')).to eq 'http://www.google.com'
    end
  end

  describe 'validate url format' do
    it { should allow_values(*correct_urls).for(:url) }
    it { should_not allow_value(*wrong_urls).for(:url) }
  end
end
