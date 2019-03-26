# == Schema Information
#
# Table name: links
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  url           :string
#  linkable_type :string
#  linkable_id   :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }

  it { should allow_value('http://google.com').for(:url) }
  it { should_not allow_value('google.com').for(:url) }

  let(:question) { create(:question) }
  let(:link) { create(:link, linkable: question) }
  let(:gist_link) { create(:link, :gist_link, linkable: question) }

  it 'method gist_link? should be return true' do
    expect(gist_link.gist_link?).to eq true
  end

  it 'method gist_link? should be return false' do
    expect(link.gist_link?).to eq false
  end

  it 'method gist_contents should be return array with content gist' do
    expect(gist_link.gist_contents).to eq ['2 * 3  = ?']
  end
end
