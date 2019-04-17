# == Schema Information
#
# Table name: authorizations
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it{ should belong_to(:user) }

  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:uid) }
end
