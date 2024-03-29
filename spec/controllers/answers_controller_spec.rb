require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    let(:post_create_valid) { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }
    let(:post_create_invalid) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post_create_valid }.to change(Answer, :count).by(1)
      end

      it 'check new answer belongs to the correct question' do
        post_create_valid
        expect(assigns(:answer).question).to eq question
      end

      it 'renders javascript code from create view' do
        post_create_valid
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post_create_invalid }.to_not change(Answer, :count)
      end

      it 'renders javascript code from create view' do
        post_create_invalid
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    let(:edit_answer_valid) do
      patch :update, params: { id: answer, answer: attributes_for(:answer, :custom) }, format: :js
      answer.reload
    end

    let(:edit_answer_invalid) do
      patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
      answer.reload
    end

    context 'answer creator' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          edit_answer_valid
          expect(answer.body).to eq attributes_for(:answer, :custom)[:body]
        end

        it 'renders javascript code from update view' do
          edit_answer_valid
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect { edit_answer_invalid }.to_not change(answer, :body)
        end

        it 'renders javascript code from update view' do
          edit_answer_invalid
          expect(response).to render_template :update
        end
      end
    end

    context 'another user' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it 'does not change answer attributes' do
        expect { edit_answer_valid }.to_not change(answer, :body)
      end

      it 'renders javascript code from update view' do
        edit_answer_valid
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:delete_answer){ delete :destroy, params: { id: answer }, format: :js }

    context 'answer creator' do
      before { login(user) }

      it 'deletes answer from database' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'renders javascript code from destroy view' do
        delete_answer
        expect(response).to render_template :destroy
      end
    end

    context 'another user' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it 'leaves answer in database' do
        expect { delete_answer }.to_not change(Answer, :count)
      end

      it 'renders javascript code from destroy view' do
        delete_answer
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:mark_answer_as_best){ patch :mark_as_best, params: { id: answer }, format: :js }

    context 'questions creator' do
      before { login(user) }

      it "changes question's best answer to selected answer in database" do
        mark_answer_as_best
        expect(answer.question.reload.best_answer_id).to eq answer.id
      end

      it "renders javascript code from mark_as_best view" do
        mark_answer_as_best
        expect(response).to render_template :mark_as_best
      end
    end

    context 'another user' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it "does not change question's best answer in database" do
        expect { mark_answer_as_best }.to_not change { answer.question.reload.best_answer_id }
      end

      it "returns 204 status code" do
        mark_answer_as_best
        expect(response).to have_http_status(:not_acceptable)
      end
    end
  end
end
