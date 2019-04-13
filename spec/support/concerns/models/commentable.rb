require 'rails_helper'

shared_examples_for 'has many comments' do
  it { should have_many(:comments).dependent(:delete_all) }
end
