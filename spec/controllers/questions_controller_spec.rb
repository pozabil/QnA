require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'POST #create' do
    let(:post_create_valid) { post :create, params: { question: attributes_for(:question) } }
    let(:post_create_invalid) { post :create, params: { question: attributes_for(:question, :invalid) } }

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
end
