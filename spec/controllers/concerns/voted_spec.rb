require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  with_model :WithVoteable do
    table do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :rating, default: 0, null: false
    end

    model do
      include Voteable

      belongs_to :user
    end
  end

  controller do 
    include Voted

    def self.controller_name
      'with_voteables'
    end
  end

  before do
    routes.draw do
      concern :voteable do
        member do
          patch :upvote
          patch :downvote
        end
      end

      resources :with_voteables, only: [], concerns: [:voteable], controller: :anonymous
    end
  end

  let(:user) { create(:user) }
  let!(:with_voteable) { WithVoteable.create(user: user) }

  describe 'PATCH #upvote' do
    let(:upvote_with_voteable) { patch :upvote, params: { id: with_voteable }, format: :js }

    context 'with_voteable creator' do
      before { login(user) }

      it "does not change with_voteable's rating in database" do
        expect { upvote_with_voteable }.to_not change { with_voteable.reload.rating }
      end

      it "returns status 204" do
        upvote_with_voteable
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'another user' do
      let(:another_user) { create(:user) }
      let(:user_voteable) { UserVoteable.create(user: another_user, voteable: with_voteable) }

      before { login(another_user) }

      context "with_voteable they haven't voted yet" do
        it "increse with_voteable's rating in database" do
          expect { upvote_with_voteable }.to change { with_voteable.reload.rating }.by(1)
        end

        it "renders json" do
          upvote_with_voteable
          expect(JSON.parse(response.body)).to eq({ 'with_voteable' => { 'id' => with_voteable.id,
                                                                         'rating' => with_voteable.reload.rating,
                                                                         'action' => 'upvote' } })
        end
      end

      context "with_voteable they upvoted" do
        before do
          user_voteable.up!
          with_voteable.update_rating
        end

        it "decrease with_voteable's rating in database" do
          expect { upvote_with_voteable }.to change { with_voteable.reload.rating }.by(-1)
        end

        it "renders json" do
          upvote_with_voteable
          expect(JSON.parse(response.body)).to eq({ 'with_voteable' => { 'id' => with_voteable.id,
                                                                         'rating' => with_voteable.reload.rating,
                                                                         'action' => 'upvote' } })
        end
      end

      context "with_voteable they downvoted" do
        before do
          user_voteable.down!
          with_voteable.update_rating
        end

        it "increse with_voteable's rating in database" do
          expect { upvote_with_voteable }.to change { with_voteable.reload.rating }.by(2)
        end

        it "renders json" do
          upvote_with_voteable
          expect(JSON.parse(response.body)).to eq({ 'with_voteable' => { 'id' => with_voteable.id,
                                                                         'rating' => with_voteable.reload.rating,
                                                                         'action' => 'upvote' } })
        end
      end

      context "with_voteable they removed vote" do
        before do
          user_voteable.no_impact!
          with_voteable.update_rating
        end

        it "increse with_voteable's rating in database" do
          expect { upvote_with_voteable }.to change { with_voteable.reload.rating }.by(1)
        end

        it "renders json" do
          upvote_with_voteable
          expect(JSON.parse(response.body)).to eq({ 'with_voteable' => { 'id' => with_voteable.id,
                                                                         'rating' => with_voteable.reload.rating,
                                                                         'action' => 'upvote' } })
        end
      end
    end
  end

  describe 'PATCH #downvote' do
    let(:downvote_with_voteable){ patch :downvote, params: { id: with_voteable }, format: :js }

    context 'with_voteable creator' do
      before { login(user) }

      it "does not change with_voteable's rating in database" do
        expect { downvote_with_voteable }.to_not change { with_voteable.reload.rating }
      end

      it "returns status 204" do
        downvote_with_voteable
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'another user' do
      let(:another_user) { create(:user) }
      let(:user_voteable) { UserVoteable.create(user: another_user, voteable: with_voteable) }

      before { login(another_user) }

      context "with_voteable they haven't voted yet" do
        it "decrease with_voteable's rating in database" do
          expect { downvote_with_voteable }.to change { with_voteable.reload.rating }.by(-1)
        end

        it "renders json" do
          downvote_with_voteable
          expect(JSON.parse(response.body)).to eq({ 'with_voteable' => { 'id' => with_voteable.id,
                                                                         'rating' => with_voteable.reload.rating,
                                                                         'action' => 'downvote' } })
        end
      end

      context "with_voteable they upvoted" do
        before do
          user_voteable.up!
          with_voteable.update_rating
        end

        it "decrease with_voteable's rating in database" do
          expect { downvote_with_voteable }.to change { with_voteable.reload.rating }.by(-2)
        end

        it "renders json" do
          downvote_with_voteable
          expect(JSON.parse(response.body)).to eq({ 'with_voteable' => { 'id' => with_voteable.id,
                                                                         'rating' => with_voteable.reload.rating,
                                                                         'action' => 'downvote' } })
        end
      end

      context "with_voteable they downvoted" do
        before do
          user_voteable.down!
          with_voteable.update_rating
        end

        it "increse with_voteable's rating in database" do
          expect { downvote_with_voteable }.to change { with_voteable.reload.rating }.by(1)
        end

        it "renders json" do
          downvote_with_voteable
          expect(JSON.parse(response.body)).to eq({ 'with_voteable' => { 'id' => with_voteable.id,
                                                                         'rating' => with_voteable.reload.rating,
                                                                         'action' => 'downvote' } })
        end
      end

      context "with_voteable they removed vote" do
        before do
          user_voteable.no_impact!
          with_voteable.update_rating
        end

        it "decrease with_voteable's rating in database" do
          expect { downvote_with_voteable }.to change { with_voteable.reload.rating }.by(-1)
        end

        it "renders json" do
          downvote_with_voteable
          expect(JSON.parse(response.body)).to eq({ 'with_voteable' => { 'id' => with_voteable.id,
                                                                         'rating' => with_voteable.reload.rating,
                                                                         'action' => 'downvote' } })
        end
      end
    end
  end
end
