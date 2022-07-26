require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }

  describe 'POST #create' do
    let(:post_create_valid) { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }
    let(:post_create_invalid) { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post_create_valid }.to change(Answer, :count).by(1)
      end

      it 'check new answer belongs to the correct question' do
        post_create_valid
        expect(assigns(:exposed_answer).question).to eq question
      end

      it 'redirects to parent question show view' do
        post_create_valid
        expect(response).to redirect_to assigns(:exposed_answer).question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post_create_invalid }.to_not change(Answer, :count)
      end

      it 're-renders show view' do
        post_create_invalid
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
