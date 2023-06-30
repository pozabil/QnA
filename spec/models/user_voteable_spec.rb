require 'rails_helper'

RSpec.describe UserVoteable, type: :model do
  let(:user) { create(:user) }
  let(:voteable) { create(:question, user: user) }

  it { should define_enum_for(:impact).with_values(down: -1, no_impact: 0, up: 1) }
  it { should belong_to :voteable }
  it { should belong_to :user }

  describe 'uniqueness validation' do
    subject { build(:user_voteable, user: user, voteable: voteable) }
    it { should validate_uniqueness_of(:user).scoped_to([:voteable_id, :voteable_type]) }
  end
end
