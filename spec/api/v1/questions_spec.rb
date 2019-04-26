require 'rails_helper'

describe 'Questions Api', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }
  let(:method) { 'get' }

  describe 'GET /api/v1/questions' do

    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'Api Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:json_questions) { json['questions'] }
      let(:json_question) { json_questions.first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:keys) { %w[id body title body created_at updated_at] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'Return response status', 200

      it_behaves_like 'Return list objects', 2, 'json_questions'

      it_behaves_like 'Return all public fields', 'json_question', 'question'

      it 'contains user object' do
        expect(json_question['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(json_question['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:json_answers) { json_question['answers'] }
        let(:json_answer) { json_answers.first }
        let(:keys) { %w[id body user_id created_at updated_at] }

        it_behaves_like 'Return list objects', 3, 'json_answers'

        it_behaves_like 'Return all public fields', 'json_answer', 'answer'
      end
    end
  end

  describe '/api/v1/questions/:id' do
    let!(:question) { create(:question, :attached) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:json_question) { json['question'] }
    let!(:comments) { create_list(:comment, 3, commentable: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }

    it_behaves_like 'Api Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:keys) { %w[id body title created_at updated_at] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'Return response status', 200

      it_behaves_like 'Return all public fields', 'json_question', 'question'

      it 'contains user object' do
        expect(json_question['user']['id']).to eq question.user.id
      end

      describe 'comments' do
        let(:comment) { comments.last }
        let(:json_comments) { json_question['comments'] }
        let(:json_comment) { json_comments.first }
        let(:keys) { %w[id body user_id commentable_type commentable_id] }

        it_behaves_like 'Return list objects', 3, 'json_comments'
        it_behaves_like 'Return all public fields', 'json_comment', 'comment'
      end

      describe 'links' do
        let(:link) { links.last }
        let(:json_links) { json_question['links'] }
        let(:json_link) { json_links.first }
        let(:keys) { %w[name url] }

        it_behaves_like 'Return list objects', 3, 'json_links'
        it_behaves_like 'Return all public fields', 'json_link', 'link'
      end

      describe 'attachments' do
        let(:json_attached) { json_question['attachments'] }
        let(:attachment) { question.files.first }

        it 'contains attachment url' do
          expect(json_attached[0]['url']).to eq rails_blob_path(attachment, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { 'post' }
    let(:headers) { nil }

    it_behaves_like 'Api Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:created_object) { Question.find(json['question']['id']) }

      context 'request' do
        before do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question), format: :json }
        end

        it_behaves_like 'Return response status', 200
      end

      context 'with valid attributes' do
        subject do
          post api_path, params: { access_token: access_token.token, question: { title: 'title', body: 'body'}, format: :json }
        end

        it_behaves_like 'change count object', Question, 1

        it_behaves_like 'return object', Question

        it 'creates question with correct attributes' do
          subject
          expect(Question.last.title).to eq 'title'
          expect(Question.last.body).to eq 'body'
        end

        it_behaves_like 'assign correct user association to new created object', Question
      end

      context 'with invalid attributes' do
        subject do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid), format: :json }
        end

        it_behaves_like 'not change count object', Question

        it_behaves_like 'returns unprocessable entity'
      end

      it 'returns error messages' do
        post api_path,
             params: {  access_token: access_token.token, question: { title: nil }, format: :json }

        expect(json).to include "Title can't be blank"
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:me) { create(:user) }
    let!(:question) { create(:question, user: me) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { 'patch' }
    let(:headers) { nil }
    let(:created_object) { Question.find(json['question']['id']) }

    it_behaves_like 'Api Authorizable'

    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    context 'request' do
      before do
        patch api_path, params: { id: question,
                                  access_token: access_token.token,
                                  question: attributes_for(:question),
                                  format: :json }
      end

      it_behaves_like 'Return response status', 200
    end

    context 'with valid attributes' do
      subject do
        patch api_path, params: { id: question,
                                  access_token: access_token.token,
                                  question: { title: 'new title', body: 'new body'},
                                  format: :json }
      end

      it 'changed question attributes' do
        subject
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it_behaves_like 'return object', Question
    end

    context 'with invalid attributes' do
      subject do
        patch api_path, params: { id: question,
                                  access_token: access_token.token,
                                  question: attributes_for(:question, :invalid),
                                  format: :json }
      end

      it 'not changed question attributes' do
        correct_title = question.title
        correct_body = question.body

        subject
        question.reload

        expect(question.title).to eq correct_title
        expect(question.body).to eq correct_body
      end

      it_behaves_like 'returns unprocessable entity'
    end

    context 'tries change by another user' do
      let(:not_owner) { create(:user) }
      let(:not_owner_access_token) { create(:access_token, resource_owner_id: not_owner.id) }

      before do
        patch api_path, params: { id: question,
                                  access_token: not_owner_access_token.token,
                                  question: attributes_for(:question),
                                  format: :json }
      end

      it_behaves_like 'Return response status', 403
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:me) { create(:user) }
    let!(:question) { create(:question, user: me) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { 'delete' }
    let(:headers) { nil }

    it_behaves_like 'Api Authorizable'

    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    context 'owner question' do
      subject do
        delete api_path, params: { id: question,
                                   access_token: access_token.token,
                                   format: :json }
      end

      it_behaves_like 'change count object', Question, -1
    end

    context 'not owner question' do
      let(:not_owner) { create(:user) }
      let(:not_owner_access_token) { create(:access_token, resource_owner_id: not_owner.id) }

      context 'response' do
        before do
          delete api_path, params: { id: question,
                                     access_token: not_owner_access_token.token,
                                     format: :json }
        end

        it_behaves_like 'Return response status', 403
      end

      it 'can not delete question' do
        subject do
          delete api_path, params: { id: question,
                                     access_token: access_token.token,
                                     format: :json }
        end
        expect { subject }.to_not change(Question, :count)
      end
    end
  end
end
