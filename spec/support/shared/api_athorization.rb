shared_examples_for 'Api Authorizable' do

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        do_request(method, api_path, headers: headers )
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
        expect(response.status).to eq 401
      end
    end
  end
end

shared_examples 'Return list objects' do |size, json_objectable|
  let(:json_objects) { send(json_objectable) }

  it "returns list of objects" do
    expect(json_objects.size).to eq size
  end
end

shared_examples 'Return response status' do |status|
  it "returns status #{status}" do
    expect(response.status).to eq status
  end
end

shared_examples 'Return all public fields' do |json_objectable, objectable|
  let(:json_object) { send(json_objectable) }
  let(:object) { send(objectable) }

  it "return all public fields for objects" do
    keys.each do |attr|
      expect(json_object[attr]).to eq object.send(attr).as_json
    end
  end
end

shared_examples 'change count object' do |klass, count|
  it 'in database' do
    expect { subject }.to change(klass, :count).by(count)
  end
end

shared_examples 'return object' do |klass|
  it 'return object' do
    subject
    expect(created_object).to be_a(klass)
  end
end

shared_examples 'assign correct user association to new created object' do |klass|
  it 'assign correct user association to new created object' do
    subject
    expect(klass.first.user_id).to eq access_token.resource_owner_id
  end
end

shared_examples 'not change count object' do |klass|
  it 'in database' do
    expect { subject }.to_not change(klass, :count)
  end
end

shared_examples_for 'returns unprocessable entity' do
  it 'status' do
    subject
    expect(response).to have_http_status :unprocessable_entity
  end
end


