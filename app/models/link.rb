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

class Link < ApplicationRecord
  GIST_URL = 'gist.github.com'.freeze

  FORMAT_URL = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: FORMAT_URL, message: 'Invalid format url' }

  def gist_link?
   parse_url = url.split('/')
   parse_url[2] == GIST_URL
  end

  def gist_contents
    client = Octokit::Client.new(access_token: ENV['GISTS_ACCESS_TOKEN'])
    gist = client.gist(gist_id)
    files = {}

    gist.files.each do |k, v|
      files[k] = v[:content]
    end

    files.values
  end

  private

  def gist_id
    url.split('/').last
  end
end
