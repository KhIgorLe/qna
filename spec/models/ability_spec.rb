require 'rails_helper'

RSpec.describe Ability do

  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Badge }
    it { should be_able_to :read, Link }
    it { should be_able_to :read, Vote }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other_user), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other_user), user: user }

    context 'rating' do
      let(:question) { create(:question, user: other_user) }
      let(:answer) { create(:answer, user: other_user, question: question) }

      context 'up_rating' do
        it { should be_able_to :up_rating, question, user: user }
        it { should_not be_able_to :up_rating, create(:question, user: user), user: user }
        it { should_not be_able_to :up_rating, question.up_rating(user), user: user }

        it { should be_able_to :up_rating, answer, user: user }
        it { should_not be_able_to :up_rating, create(:answer, user: user), user: user }
        it { should_not be_able_to :up_rating, answer.up_rating(user), user: user }
      end

      context 'down_rating' do
        it { should be_able_to :down_rating, question, user: user }
        it { should_not be_able_to :down_rating, create(:question, user: user), user: user }
        it { should_not be_able_to :down_rating, question.down_rating(user), user: user }

        it { should be_able_to :down_rating, answer, user: user }
        it { should_not be_able_to :down_rating, create(:answer, user: user), user: user }
        it { should_not be_able_to :down_rating, answer.down_rating(user), user: user }
      end

      context 'un_rating' do
        context 'user can un rating ' do
          before do
            question.up_rating(user)
            answer.up_rating(user)
          end

          it { should be_able_to :un_rating, question, user: user }
          it { should be_able_to :un_rating, answer, user: user }
        end

        context 'user cannot un rating' do
          it { should_not be_able_to :un_rating, question, user: user }
          it { should_not be_able_to :un_rating, answer, user: user }
        end
      end
    end

    context 'make_best' do
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, user: other_user, question: question) }

      context 'can best' do
        it { should be_able_to :make_best, answer , user: user}
      end

      context 'cannot make best' do
        before do
          answer.make_best!
        end

        it { should_not be_able_to :make_best, answer , user: user}
      end
    end

    context 'destroy attachment' do
      let(:question) { create(:question, :attached, user: user) }
      let(:attachment) { question.files.first }
      let(:answer) { create(:answer, :attached, user: other_user ) }
      let(:other_attachment) { answer.files.first }

      it { should be_able_to :destroy, attachment, user: user }
      it { should_not be_able_to :destroy, other_attachment, user: user }
    end
  end
end
