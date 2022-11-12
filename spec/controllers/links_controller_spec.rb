require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    let!(:link) { create(:link, linkable: question) }
    let(:remove_link){ delete :destroy, params: { id: link }, format: :js }

    context 'link creator' do
      before { login(user) }

      it 'deletes link from database' do
        expect { remove_link }.to change(Link, :count).by(-1)
      end

      it 'renders javascript code from destroy view' do
        remove_link
        expect(response).to render_template :destroy
      end
    end

    context "another user" do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it 'leaves file from database' do
        expect { remove_link }.to_not change(Link, :count)
      end

      it 'renders javascript code from destroy view' do
        remove_link
        expect(response).to render_template :destroy
      end
    end
  end
end
