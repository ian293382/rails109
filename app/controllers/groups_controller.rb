class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :creat, :edit, :update ,:destroy, :join, :quit]
  before_action :find_group_and_check_permission, only: [:edit, :update,  :destroy]
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end


  def create
    @group = Group.new(group_params)
    @group.user = current_user

      if @group.save
        current_user.join!(@group)
        redirect_to groups_path
        else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit

  end

  def update



    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy



    @group.destroy
    flash[:alert] = "Group delete"
    redirect_to groups_path
  end


  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
        flash[:notice] = "Join Success!"
      else
        flash[:warning] = "U r already in Group"
      end

      redirect_to group_path(@group)
    end


    def quit
      @group = Group.find(params[:id])

      if current_user.is_member_of?(@group)
        current_user.quit!(@group)
        flash[:alert] = "U r already quit group"
      else
        flash[:warning] = " you r not member , how to quit "
      end
    redirect_to group_path(@group)
  end


  private

  def group_params
    params.require(:group).permit(:title, :description)
  end

  def find_group_and_check_permission
    @group = Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "You have no permiission."
    end
  end

end
