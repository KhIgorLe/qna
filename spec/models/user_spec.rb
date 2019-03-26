# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:badges) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_user) { create(:user) }

  it 'method is_author? should be return true' do
    expect(user).to be_is_author(question)
  end

  it 'method author_of? should be return false' do
    expect(another_user).to_not be_is_author(question)
  end
end
