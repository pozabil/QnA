require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 5, user_id: user.id)}

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question, user_id: user.id) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

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
        expect(response).to redirect_to assigns(:question)
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

  describe 'PATCH #create' do
    let!(:question) { create(:question, user_id: user.id) }

    let(:edit_question_valid) do
      patch :update, params: { id: question, question: attributes_for(:question, :custom) }, format: :js
      question.reload
    end

    let(:edit_question_invalid) do
      patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
      question.reload
    end

    context 'question creator' do
      RSpec::Matchers.define_negated_matcher :not_change, :change

      before { login(user) }

      context 'with valid attributes' do
        it 'changes question attributes' do
          edit_question_valid
          expect(question.title).to eq attributes_for(:question, :custom)[:title]
          expect(question.body).to eq attributes_for(:question, :custom)[:body]
        end

        it 'renders javascript code from update view' do
          edit_question_valid
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change question attributes' do
          expect { edit_question_invalid }.to not_change(question, :title).and not_change(question, :body)
        end

        it 'renders javascript code from update view' do
          edit_question_invalid
          expect(response).to render_template :update
        end
      end
    end

    context 'another user' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it 'does not change question attributes' do
        expect { edit_question_valid }.to not_change(question, :title).and not_change(question, :body)
      end

      it 'renders javascript code from update view' do
        edit_question_valid
        expect(response).to render_template :update
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
