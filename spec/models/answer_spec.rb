# == Schema Information
#
# Table name: answers
#
#  id          :bigint(8)        not null, primary key
#  body        :text
#  question_id :bigint(8)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of(:body) }
end
