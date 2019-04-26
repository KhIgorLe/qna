require 'rails_helper.rb'

describe 'Answers Api', type: :request  do

  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }
  let(:method) { 'get' }

  describe '/api/v1/answers/:id' do
    let!(:answer) { create(:answer, :attached) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:json_answer) { json['answer'] }
    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let!(:links) { create_list(:link, 3, linkable: answer) }

    it_behaves_like 'Api Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:keys) { %w[id body user_id created_at updated_at] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'Return response status', 200

      it_behaves_like 'Return all public fields', 'json_answer', 'answer'

      it 'contains user object' do
        expect(json_answer['user']['id']).to eq answer.user.id
      end

      describe 'comments' do
        let(:comment) { comments.last }
        let(:json_comments) { json_answer['comments'] }
        let(:json_comment) { json_comments.first }
        let(:keys) { %w[id body user_id commentable_type commentable_id] }

        it_behaves_like 'Return list objects', 3, 'json_comments'
        it_behaves_like 'Return all public fields', 'json_comment', 'comment'
      end

      describe 'links' do
        let(:link) { links.last }
        let(:json_links) { json_answer['links'] }
        let(:json_link) { json_links.first }
        let(:keys) { %w[name url] }

        it_behaves_like 'Return list objects', 3, 'json_links'
        it_behaves_like 'Return all public fields', 'json_link', 'link'
      end

      describe 'attachments' do
        let(:json_attached) { json_answer['attachments'] }
        let(:attachment) { answer.files.first }

        it 'contains attachment url' do
          expect(json_attached[0]['url']).to eq rails_blob_path(attachment, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { 'post' }
    let(:headers) { nil }

    it_behaves_like 'Api Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:created_object) { Answer.find(json['answer']['id']) }

      context 'request' do
        before do
          post api_path, params: { access_token: access_token.token,
                                   question_id: question,
                                   answer: attributes_for(:answer),
                                   format: :json }
        end

        it_behaves_like 'Return response status', 200
      end

      context 'with valid attributes' do
        subject do
          post api_path, params: { access_token: access_token.token,
                                   question_id: question,
                                   answer: { body: 'body'}, format: :json }
        end

        it_behaves_like 'change count object', Answer, 1

        it_behaves_like 'return object', Answer

        it 'create question with correct attributes' do
          subject
          expect(Answer.last.body).to eq 'body'
        end

        it_behaves_like 'assign correct user association to new created object', Answer
      end

      context 'with invalid attributes' do
        subject do
          post api_path, params: { access_token: access_token.token,
                                   question_id: question,
                                   answer: attributes_for(:answer, :invalid),
                                   format: :json }
        end

        it_behaves_like 'not change count object', Answer

        it_behaves_like 'returns unprocessable entity'
      end

      it 'returns error messages' do
        post api_path,
             params: {  access_token: access_token.token,
                        question_id: question,
                        answer: { body: nil },
                        format: :json }

        expect(json).to include "Body can't be blank"
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:me) { create(:user) }
    let!(:answer) { create(:answer, user: me) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { 'patch' }
    let(:headers) { nil }
    let(:created_object) { Answer.find(json['answer']['id']) }

    it_behaves_like 'Api Authorizable'

    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    context 'request' do
      before do
        patch api_path, params: { id: answer,
                                  access_token: access_token.token,
                                  answer: attributes_for(:answer),
                                  format: :json }
      end

      it_behaves_like 'Return response status', 200
    end

    context 'with valid attributes' do
      subject do
        patch api_path, params: { id: answer,
                                  access_token: access_token.token,
                                  answer: { body: 'new body' },
                                  format: :json }
      end

      it 'changed answer attributes' do
        subject
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it_behaves_like 'return object', Answer
    end

    context 'with invalid attributes' do
      subject do
        patch api_path, params: { id: answer,
                                  access_token: access_token.token,
                                  answer: attributes_for(:answer, :invalid),
                                  format: :json }
      end

      it 'not changed answer attributes' do
        correct_body = answer.body

        subject
        answer.reload

        expect(answer.body).to eq correct_body
      end

      it_behaves_like 'returns unprocessable entity'

      context 'tries change by another user' do
        let(:not_owner) { create(:user) }
        let(:not_owner_access_token) { create(:access_token, resource_owner_id: not_owner.id) }

        before do
          patch api_path, params: { id: answer,
                                    access_token: not_owner_access_token.token,
                                    answer: attributes_for(:answer),
                                    format: :json }
        end

        it_behaves_like 'Return response status', 403
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:me) { create(:user) }
    let!(:answer) { create(:answer, user: me) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { 'delete' }
    let(:headers) { nil }

    it_behaves_like 'Api Authorizable'

    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    context 'owner question' do
      subject do
        delete api_path, params: { id: answer,
                                   access_token: access_token.token,
                                   format: :json }
      end

      it 'delete question' do
        expect { subject }.to change(Answer, :count).by(-1)
      end

      it_behaves_like 'change count object', Answer, -1
    end

    context 'not owner question' do
      let(:not_owner) { create(:user) }
      let(:not_owner_access_token) { create(:access_token, resource_owner_id: not_owner.id) }

      context 'response' do
        before do
          delete api_path, params: { id: answer,
                                     access_token: not_owner_access_token.token,
                                     format: :json }
        end

        it_behaves_like 'Return response status', 403
      end

      it 'can not delete question' do
        subject do
          delete api_path, params: { id: answer,
                                     access_token: access_token.token,
                                     format: :json }
        end
        expect { subject }.to_not change(Answer, :count)
      end
    end
  end
end
