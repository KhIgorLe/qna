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
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end

        it 'save answer in database' do
          expect {subject}.to change(question.answers, :count).by(1)
        end

        it 'new answer has owner' do
          subject
          expect(assigns(:answer).user).to eq user
        end

        it 'renders create template ' do
          subject
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        subject do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        end

        it 'not save answer in database' do
          expect { subject }.to_not change(Answer, :count)
        end

        it 're-render create template' do
          subject
          expect(response).to render_template :create
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

  describe 'PATH #update' do
    let(:answer) { create(:answer, question: question, user: user) }

    describe 'login by owner user' do
      before { login(user) }

      context 'with valid attributes' do
        subject { patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js }

        it 'changes answer attributes' do
          subject
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          subject

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        subject { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'not change answer attributes' do
          expect do
            subject
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          subject

          expect(response).to render_template :update
        end
      end
    end

    context 'login by another user' do
      before { login(another_user) }
      subject { patch :update, params: { id: answer, answer: { body: 'New body'}  }, format: :js }

      it 'can not change answer attributes' do
        subject

        expect(assigns(:answer).body).to_not eq 'New body'
      end

      it 'redirect to root path' do
        subject

        expect(response).to redirect_to root_path
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    subject do
      delete :destroy, params: { question_id: question, id: answer, format: :js }
    end

    context 'owner user' do
      before { login(user) }

      it 'delete answer' do
        expect { subject }.to change(Answer, :count).by(-1)
      end
    end

    context 'login by another user' do
      before { login(another_user) }

      it 'can not delete question' do
        expect { subject }.to_not change(Answer, :count)
      end

      it 'redirect to root path' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #make_best' do
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }

    context 'login by question owner user' do
      before do
        login(user)
        patch :make_best, params: { id: answer, format: :js }
      end

      it 'change best answer for question' do
        answer.reload

        expect(answer).to be_best
      end

      it 'renders make_best view ' do
        expect(response).to render_template :make_best
      end
    end

    context 'login by another user' do
      before do
        login(another_user)
        patch :make_best, params: { id: answer, format: :js }
      end

      it 'can not change best answer for question' do
        answer.reload

        expect(answer).to_not be_best
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
