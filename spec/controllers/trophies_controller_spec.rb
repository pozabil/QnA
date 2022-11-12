require 'rails_helper'

RSpec.describe TrophiesController, type: :controller do
  let(:user) { create(:user) }
  let(:questions) { create_list(:question, 4, user: user) }

  describe 'GET #index' do
    2.times { |i| eval("let!(:trophy_#{i+1}) { create(:trophy, question: questions[#{i+1}]) }") }
    4.times { |i| eval("let!(:user_answer_to_question_#{i}) { create(:answer, question: questions[#{i}], user: user) }") }

    before do
      3.times { |i| eval("user_answer_to_question_#{i}.mark_as_best") }
      login(user)
      get :index
    end

    it "populates an array of all user's trophies" do
      expect(assigns(:trophies)).to match_array [trophy_1, trophy_2]
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
