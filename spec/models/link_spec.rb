require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '.format_url' do
    it 'returns correct formatted url string' do
      expect(described_class.format_url('  www.google.com  ')).to eq 'http://www.google.com'
    end
  end

  describe 'validate url format' do
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

    it { should allow_values(*correct_urls).for(:url) }
    it { should_not allow_value(*wrong_urls).for(:url) }
  end

  describe '#gist?' do
    let (:user) { create(:user) }
    let (:question) { create :question, user: user }
    let (:some_gist_link) { create(:link, :gist_plain_text, linkable: question) }
    let (:not_some_gist_links) { [
      question.links.create!(name: 'google', url: 'https://google.com'),
      question.links.create!(name: 'gist homepage', url: 'https://gist.github.com/'),
      question.links.create!(name: 'random profile gist list', url: 'https://gist.github.com/rails'),
      question.links.create!(name: 'random profile starred gist list', url: 'https://gist.github.com/rails/starred')
    ] }

    it 'returns true if the link is a link to some gist' do
      expect(some_gist_link.gist?).to be true
    end

    it 'returns false if the link is not a link to some gist' do
      not_some_gist_links.each { |link| expect(link.gist?).to be false }
    end
  end
end
