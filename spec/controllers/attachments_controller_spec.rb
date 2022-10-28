require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    let!(:file) do
      question.files.attach(io: File.open("#{Rails.root}/spec/controllers/questions_controller_spec.rb"), filename: "questions_controller_spec.rb")
      question.files.last
    end

    let(:remove_attachment){ delete :destroy, params: { id: file }, format: :js }

    context 'question creator' do
      before { login(user) }

      it 'deletes file from database' do
        expect { remove_attachment }.to change(question.files, :count).by(-1)
      end

      it 'renders javascript code from destroy view' do
        remove_attachment
        expect(response).to render_template :destroy
      end
    end

    context "another user" do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it 'leaves file from database' do
        expect { remove_attachment }.to_not change(question.files, :count)
      end

      it 'renders javascript code from destroy view' do
        remove_attachment
        expect(response).to render_template :destroy
      end
    end
  end
end
