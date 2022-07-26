require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:post_create_valid) { post :create, params: { question: attributes_for(:question) } }
    let(:post_create_invalid) { post :create, params: { question: attributes_for(:question, :invalid) } }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post_create_valid }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post_create_valid
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post_create_invalid }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post_create_invalid
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user_id: user.id) }
    let(:delete_question){ delete :destroy, params: { id: question } }

    context 'question creator' do
      before { login(user) }

      it 'deletes question from database' do
        expect { delete_question }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete_question
        expect(response).to redirect_to questions_path
      end
    end

    context "another user" do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it 'leaves question in database' do
        expect { delete_question }.to_not change(Question, :count)
      end

      it 're-renders show view' do
        delete_question
        expect(response).to render_template :show
      end
    end
  end
end
