require 'rails_helper'

RSpec.describe Trophy, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it { should belong_to :question }

  it { should validate_presence_of :title }
  it { should validate_presence_of :image }

  it 'have one attached image' do
    expect(Trophy.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
