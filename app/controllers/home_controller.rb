class HomeController < ApplicationController
  def index
    if user_signed_in?
      @folders = current_user.folders.roots
      @assets = current_user.assets.where("folder_id is NULL").order("uploaded_file_file_name desc")
    end
  end
  def browse
    @current_folder = current_user.folders.find(params[:folder_id])
    if @current_folder
      @folders = @current_folder.children
      @assets = @current_folder.assets.order("uploaded_file_file_name desc")
      render :action => "index"
    else
      flash[:error] = "Don't be cheeky! Mind your own folders!"
      redirect_to root_url
    end
  end
  def share
    email_addresses = params[:email_addresses].split(",")
    email_addresses.each do |email_address|
      @shared_folder = current_user.shared_folders.new
      @shared_folder.folder_id = params[:folder_id]
      @shared_folder.shared_email = email_address

      shared_user = User.find_by_email(email_address)
      @shared_folder.message = params[:message]
      @shared_folder.save
      respond_to do |format|
       format.js
      end
    end
  end
end
