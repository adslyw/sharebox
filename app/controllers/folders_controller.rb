class FoldersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @folders = current_user.folders
  end

  def show
    @folder =current_user.folders.find(params[:id])
  end

  def new
    @folder = current_user.folders.new
    if params[:folder_id]
      @current_folder = current_user.folders.find(params[:folder_id])
      @folder.parent_id = @current_folder.id
    end
  end

  def create
    @folder = current_user.folders.new(params[:folder])
    if @folder.save
      if @folder.parent
        redirect_to browse_path(@folder.parent)
      else
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @folder = current_user.folders.find(params[:folder_id])
    @current_folder = @folder.parent
  end

  def update
    @folder = current_user.folders.find(params[:id])
    @parrent_folder = @folder.parent
    if @folder.update_attributes(params[:folder])
      flash[:notice] = "Successfully updated folder."
      if @parrent_folder
        redirect_to browse_path(@parrent_folder)
      else
        redirect_to root_url
      end      
    else
      render :action => 'edit'
    end
  end

  def destroy
    @folder = current_user.folders.find(params[:id])
    @parent_folder = @folder.parent
    @folder.destroy
    flash[:notice] = "Successfully destroyed folder."
    if @parent_folder
      redirect_to browse_path(@parent_folder)
    else
      redirect_to root_url
    end
  end
end
