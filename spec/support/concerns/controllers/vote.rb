require 'rails_helper'

shared_examples_for 'voteable' do |voteable|
  let(:resource) { send(voteable) }
  let(:other_user) {create(:user) }

  describe 'POST #up_rating' do
    describe 'with authenticated user not owner voteable' do
      before do
        login(other_user)
      end

      subject do
        post :up_rating, params: { id: resource, format: :json }
      end

      it { expect {subject}.to change(Vote, :count).by(1) }

      it 'render json' do
        subject
        expect(response.body).to eq "{\"rating\":1,\"id\":#{resource.id},\"klass\":\"#{resource.class.to_s}\"}"
      end

      it 'rating' do
        subject
        expect(resource.rating).to eq 1
      end
    end
  end

  describe 'POST #down_rating' do
    describe 'with authenticated user not owner voteable' do
      before { login(other_user) }

      subject do
        post :down_rating, params: { id: resource, format: :json }
      end

      it { expect {subject}.to change(Vote, :count).by(1) }

      it 'render json' do
        subject
        expect(response.body).to eq "{\"rating\":-1,\"id\":#{resource.id},\"klass\":\"#{resource.class.to_s}\"}"
      end

      it 'rating' do
        subject
        expect(resource.rating).to eq -1
      end
    end
  end

  describe 'POST #un_rating' do
    describe 'with authenticated user not owner voteable' do
      let!(:vote) { create :vote, voteable: resource, user: other_user }

      before { login(other_user) }

      subject do
        delete :un_rating, params: { id: resource, format: :json }
      end

      it { expect {subject}.to change(Vote, :count).by(-1) }

      it 'render json' do
        subject
        expect(response.body).to eq "{\"rating\":0,\"id\":#{resource.id},\"klass\":\"#{resource.class.to_s}\"}"
      end

      it 'rating' do
        subject
        expect(resource.rating).to eq 0
      end
    end
  end
end
