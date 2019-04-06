require 'rails_helper'

shared_examples_for 'has many votes' do
  it { should have_many(:votes).dependent(:delete_all) }
end

shared_examples_for 'voteable rating' do |voteable|
  let(:resource) { send(voteable) }
  let(:other_user) { create(:user) }

  describe '#up_rating not owner resource' do
    before do
      resource.up_rating(other_user)
    end

    it { expect(Vote.last.rating).to eq 1 }
  end

  describe '#up_rating owner resource' do
    before do
      resource.up_rating(owner_user)
    end

    it { expect(Vote.last).to eq nil }
  end

  describe '#up_rating when user has previously voted' do
    before do
      resource.up_rating(other_user)
      resource.up_rating(other_user)
    end

    it { expect(Vote.last.rating).to eq 1 }
  end

  describe '#down_rating not owner resource' do
    before do
      resource.down_rating(other_user)
    end

    it { expect(Vote.last.rating).to eq -1 }
  end

  describe '#down_rating owner resource' do
    before do
      resource.down_rating(owner_user)
    end

    it { expect(Vote.last).to eq nil }
  end

  describe '#down_rating when user has previously voted' do
    before do
      resource.down_rating(other_user)
      resource.down_rating(other_user)
    end

    it { expect(Vote.last.rating).to eq -1 }
  end

  describe '#un_rating owner rating' do
    before do
      resource.up_rating(other_user)
      resource.un_rating(other_user)
    end

    it { expect(Vote.last).to eq nil }
  end

  describe '#un_rating not owner rating' do
    before do
      resource.down_rating(other_user)
      resource.un_rating(owner_user)
    end

    it { expect(Vote.last.rating).to eq -1 }
  end

  describe '#rating' do
    let(:users) { create_list :user, 5 }

    before do
      (0..4).each { |i| resource.up_rating(users[i]) }
    end

    it { expect(resource.rating).to eq 5 }
  end
end
