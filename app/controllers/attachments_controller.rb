class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @record = @attachment.record
    @attachment.purge if @record.user == current_user
  end
end
