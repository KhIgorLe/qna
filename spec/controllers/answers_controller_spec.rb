require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let!(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'POST #create' do
    describe 'with authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        subject do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end

        it 'save answer in database' do
          expect {subject}.to change(question.answers, :count).by(1)
        end

        it 'new answer has owner' do
          subject
          expect(assigns(:answer).user).to eq user
        end

        it 'redirect to show view' do
          subject
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        subject do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        end

        it 'not save answer in database' do
          expect {subject}.to_not change(Answer, :count)
        end

        it 're-render new view' do
          subject
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context "Unauthenticated user" do
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'tries create answer' do
        expect { subject }.to_not change(Answer, :count)
      end

      it 're-render login page' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    subject do
      delete :destroy, params: { question_id: question, id: answer }
    end

    context 'owner user' do
      before { login(user) }

      it 'delete answer' do
        expect { subject }.to change(Answer, :count).by(-1)
      end

      it 'redirect to show view' do
        subject
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'login by another user' do
      before { login(another_user) }

      it 'can not delete question' do
        expect { subject }.to_not change(Answer, :count)
      end

      it 'redirect to show view' do
        subject
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
