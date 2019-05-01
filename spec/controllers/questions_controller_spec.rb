require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it_behaves_like 'voteable', 'question'

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

    it 'assign new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assign new subscription to @subscription' do
      expect(assigns(:subscription)).to be_a_new(Subscription)
    end

    it 'render show view ' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assign new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assign new Badge to @question' do
      expect(assigns(:question).badge).to be_a_new(Badge)
    end

    it 'render new view ' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    describe 'with authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        subject do
          post :create, params: { question: attributes_for(:question) }
        end

        it_behaves_like 'change count object', Question, 1

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

        it_behaves_like 'not change count object', Question

        it 're-render new view' do
          subject
          expect(response).to render_template :new
        end
      end
    end

    context "Unauthenticated user" do
      subject { post :create, params: { question: attributes_for(:question) } }

      it_behaves_like 'not change count object', Question

      it 're-render login page' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do

    describe 'login by owner user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          do_request(question: attributes_for(:question), format: :js)

          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          do_request(question: { title: 'new title', body: 'new body' }, format: :js)
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          do_request(question: { title: 'new title', body: 'new body' }, format: :js)
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { do_request(question: attributes_for(:question, :invalid), format: :js ) }

        it 'not change question' do
          correct_title = question.title
          correct_body = question.body

          question.reload

          expect(question.title).to eq correct_title
          expect(question.body).to eq correct_body
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context "login by another user" do
      before do
        login(another_user)
        do_request(question: { title: 'New title', body: 'New body' }, format: :js  )
      end

      it 'can not change question attributes' do
        expect(assigns(:question).title).to_not eq 'New title'
        expect(assigns(:question).title).to_not eq 'New body'
      end

      it 'redirect to root path' do
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq 'You are not authorized to access this page.'
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


      it_behaves_like 'not change count object', Question

      it 'redirect to root path' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end
end

