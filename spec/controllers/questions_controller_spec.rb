require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populated an array all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view ' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'render show view ' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'render new view ' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'render edit view ' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    describe 'with authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        subject do
          post :create, params: { question: attributes_for(:question) }
        end
        it 'save question in database' do
          expect { subject }.to change(Question, :count).by(1)
        end

        it 'new question has owner' do
          subject
          expect(assigns(:question).user).to eq user
        end

        it 'redirect to show view' do
          subject
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        subject do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end

        it 'not save question in database' do
          expect { subject }.to_not change(Question, :count)
        end

        it 're-render new view' do
          subject
          expect(response).to render_template :new
        end
      end
    end

    context "Unauthenticated user" do
      subject { post :create, params: { question: attributes_for(:question) } }

      it 'tries create question' do
        expect { subject }.to_not change(Question, :count)
      end

      it 're-render login page' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    describe 'with authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          do_request(question: attributes_for(:question))

          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          do_request(question: { title: 'new title', body: 'new body' })
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirect to updated question' do
          do_request(question: attributes_for(:question))
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { do_request(question: attributes_for(:question, :invalid)) }

        it 'not change question' do
          correct_title = question.title
          correct_body = question.body

          question.reload

          expect(question.title).to eq correct_title
          expect(question.body).to eq correct_body
        end

        it 're-render edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context "Unauthenticated user" do
      subject { post :create, params: { question: attributes_for(:question) } }

      it 'tries update question' do
        expect { subject }.to_not change(Question, :count)
      end

      it 're-render login page' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end

    def do_request(params)
      patch :update, params: { id: question }.merge(params)
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    subject { delete :destroy, params: { id: question } }
    context 'login by owner user' do
      before { login(user) }

      it 'delete question' do
        expect { subject }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        subject
        expect(response).to redirect_to questions_path
      end
    end

    context 'login by another user' do
      before { login(another_user) }

      it 'can not delete question' do
        expect { subject }.to_not change(Question, :count)
      end

      it 'redirect to show view' do
        subject
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
