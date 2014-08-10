class AssetsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @assets = current_user.assets
  end

  def show
    @asset = current_user.assets.find(params[:id])
  end

  def new
    @asset = current_user.assets.build
    if params[:folder_id]
      @current_folder = current_user.folders.find(params[:folder_id])
      @asset.folder_id = @current_folder.id
    end
  end

  def create
    @asset = current_user.assets.build(params[:asset])
    if @asset.save
      if @asset.folder
        redirect_to browse_path(@asset.folder), :notice => "Successfully created asset."
      else
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @asset = current_user.assets.find(params[:id])
  end

  def update
    @asset = current_user.assets.find(params[:id])
    if @asset.update_attributes(params[:asset])
      redirect_to @asset, :notice  => "Successfully updated asset."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @asset = current_user.assets.find(params[:id])
    @parrent_folder = @asset.folder
    @asset.destroy
    flash[:notice] = "Successfully destroyed asset."
    if @parrent_folder
      redirect_to browse_path(@parrent_folder)
    else
      redirect_to root_url
    end
  end

  def get
    asset = current_user.assets.find_by_id(params[:id])
    if asset
      send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type
    else
      flash[:error] = "Don't be cheeky! Mind your own assets!"
      redirect_to assets_path
    end
  end
end
