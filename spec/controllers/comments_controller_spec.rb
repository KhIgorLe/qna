require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }

  describe 'POST #create' do
    describe 'with authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'save comment for question in database' do
          expect {post :create, params: { question_id: question.id,
                                          comment: attributes_for(:comment),
                                          format: :js }}.to change(question.comments, :count).by(1)
        end

        it 'save comment for answer in database' do
          expect {post :create, params: { answer_id: answer.id,
                                          comment: attributes_for(:comment),
                                          format: :js }}.to change(answer.comments, :count).by(1)
        end

        it 'new comment has owner' do
          post :create, params: { question_id: question.id,
                                  comment: attributes_for(:comment),
                                  format: :js }
          expect(assigns(:comment).user).to eq user
        end


        it 'renders create template ' do
          post :create, params: { question_id: question.id,
                                  comment: attributes_for(:comment),
                                  format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        subject do
          post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid), format: :js }
        end

        it 'not save answer in database' do
          expect { subject }.to_not change(question.comments, :count)
        end

        it 're-render create template' do
          subject
          expect(response).to render_template :create
        end
      end
    end

    context "Unauthenticated user" do
      subject { post :create, params: { question_id: question.id, comment: attributes_for(:comment), format: :js } }

      it 'tries create comment' do
        expect { subject }.to_not change(question.comments, :count)
      end

      it 're-render login page' do
        subject
        expect(response.body).to eql 'You need to sign in or sign up before continuing.'
      end
    end
  end
end


