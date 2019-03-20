require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, :attached, user: user) }

  subject { delete :destroy, params: { id: attachment, format: :js } }

  describe 'DELETE #destroy' do

    describe 'for question' do
      let(:attachment) { question.files.first }

      context 'login by owner user' do
        before { login(user) }

        it 'can destroy attachment' do
          expect { subject }.to change(question.files, :count).by(-1)
        end

        it 'renders destroy view ' do
          subject
          expect(response).to render_template :destroy
        end
      end

      context 'login by another user' do
        before { login(another_user) }

        it 'can not destroy attachment' do
          expect { subject }.to_not change(question.files, :count)
        end

        it 're-render login page' do
          subject
          expect(response).to redirect_to root_path
        end
      end
    end

    describe 'for answer' do
      let(:answer) { create(:answer, :attached, question: question, user: user) }
      let(:attachment) { answer.files.first }

      context 'login by owner user' do
        before { login(user) }

        it 'can destroy attachment' do
          expect { subject }.to change(answer.files, :count).by(-1)
        end

        it 'renders make_best view ' do
          subject
          expect(response).to render_template :destroy
        end
      end

      context 'login by another user' do
        before { login(another_user) }

        it 'can not destroy attachment' do
          expect { subject }.to_not change(answer.files, :count)
        end

        it 're-render login page' do
          subject
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
