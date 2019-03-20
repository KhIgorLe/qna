class AttachmentsController < ApplicationController
  before_action :find_attachment, :not_author_resource, only: :destroy

  def destroy
    @attachment.purge
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def not_author_resource
    return if current_user.author_of?(@attachment.record)

    redirect_to root_path
  end
end
