class HomeController < ApplicationController
  def index
    if user_signed_in?
      #show folders shared by others
      @being_shared_folders = current_user.shared_folders_by_others
      @folders = current_user.folders.roots
      @assets = current_user.assets.where("folder_id is NULL").order("uploaded_file_file_name desc")
    end
  end
  def browse
     @current_folder = current_user.folders.find_by_id(params[:folder_id])
     @is_this_folder_being_shared = false if @current_folder #just an instance variable to help hiding buttons on View

    #if not found in own folders, find it in being_shared_folders
    if @current_folder.nil?
      folder = Folder.find(params[:folder_id])

      @current_folder ||= folder if current_user.has_share_access?(folder)
      @is_this_folder_being_shared = true if @current_folder #just an instance variable to help hiding buttons on View

    end
    if @current_folder
      @being_shared_folders = []
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
      @shared_folder.shared_user_id =shared_user.id if shared_user
      @shared_folder.message = params[:message]
      @shared_folder.save
      UserMailer.delay.invitation_to_share(@shared_folder)
      respond_to do |format|
       format.js
      end
    end
  end
end
