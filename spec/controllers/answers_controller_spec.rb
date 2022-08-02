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
        expect(assigns(:answer).question).to eq question
      end

      it 'redirects to parent question show view' do
        post_create_valid
        expect(response).to redirect_to assigns(:answer).question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post_create_invalid }.to_not change(Answer, :count)
      end

      it 're-renders parent question show view' do
        post_create_invalid
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
    let(:delete_answer){ delete :destroy, params: { id: answer } }

    context 'answer creator' do
      before { login(user) }

      it 'deletes answer from database' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to parent question show view' do
        delete_answer
        expect(response).to redirect_to question
      end
    end

    context 'another user' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it 'leaves answer in database' do
        expect { delete_answer }.to_not change(Answer, :count)
      end

      it 're-renders parent question show view' do
        delete_answer
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
