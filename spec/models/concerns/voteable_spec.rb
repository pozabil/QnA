require 'rails_helper'

RSpec.describe 'voteable' do
  with_model :WithVoteable do
    table { |t| t.integer :rating, default: 0, null: false }
    model { include Voteable }
  end
  subject { WithVoteable.new }

  let(:user) { create(:user) }
  let(:with_voteable) { WithVoteable.create }

  it { should have_many(:user_voteables).dependent(:destroy) }

  describe '#update_rating' do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:user_3) { create(:user) }

    before do
      with_voteable.user_voteables.create(user: user).down!
      with_voteable.user_voteables.create(user: user_1).up!
      with_voteable.user_voteables.create(user: user_2).no_impact!
      with_voteable.user_voteables.create(user: user_3).up!
      with_voteable.update_rating
    end

    it 'updates rating of voteable' do
      expect(with_voteable.rating).to eq(with_voteable.user_voteables.sum(:impact))
    end
  end

  describe '#user_rating_impact' do
    let(:user_voteable) { UserVoteable.create(user: user, voteable: with_voteable) }

    it 'returns nil if user has never voted for answer' do
      expect(with_voteable.user_rating_impact(user)).to be nil
    end

    it 'returns up if user upvote answer' do
      user_voteable.up!

      expect(with_voteable.user_rating_impact(user)).to eq 'up'
    end

    it 'returns down if user downvote answer' do
      user_voteable.down!

      expect(with_voteable.user_rating_impact(user)).to eq 'down'
    end

    it 'returns no_impact if user removed their vote for answer' do
      user_voteable.no_impact!

      expect(with_voteable.user_rating_impact(user)).to eq 'no_impact'
    end
  end
end
