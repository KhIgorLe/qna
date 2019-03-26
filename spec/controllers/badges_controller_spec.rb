require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }

  let(:badges) { create_list(:badge, 2, user: user) }

  describe 'GET #index' do

    context "owner badge" do
      before { login(user) }

      before { get :index }

      it 'populated an array user badges' do
        expect(assigns(:badges)).to match_array(badges)
      end

      it 'renders index view ' do
        expect(response).to render_template :index
      end
    end

    context "Another user" do
      before { login(another_user) }
      before { get :index }

      it 'not populated an array user badges' do
        expect(assigns(:badges)).to_not match_array(badges)
      end
    end
  end
end
