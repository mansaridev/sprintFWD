class MembersController < ApplicationController
  before_action :set_member, only: %i[show edit update destroy edit_team]
  before_action :set_team, only: %i[new create index]

  def index
    @members = @team.members

    respond_to do |format|
      format.html
      format.json { render json: @members, each_serializer: MemberSerializer }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @member, serializer: MemberSerializer }
    end
  end

  def new
    @member = @team.members.build
  end

  def create
    @member = @team.members.build(member_params)

    respond_to do |format|
      if @member.save
        format.html do
          flash[:success] = I18n.t('flash.success.member_created')
          redirect_to @member
        end
        format.json { render json: { message: I18n.t('flash.success.member_created'), member: @member, serializer: MemberSerializer }, status: :created }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html do
          flash[:success] = I18n.t('flash.success.member_updated')
          redirect_to @member
        end
        format.json { render json: @member, serializer: MemberSerializer, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @member.destroy
      respond_to do |format|
        format.html do
          flash[:success] = I18n.t('member.member_destroyed')
          redirect_to root_path
        end
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = I18n.t('member.member_deletion_failed', error: '')
          redirect_to root_path
        end
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def members
    @members = Member.page(params[:page]).per(8)

    respond_to do |format|
      format.html
      format.json { render json: @members, each_serializer: MemberSerializer }
    end
  end

  private

  def set_member
    @member = Member.find(params[:id] || params[:member_id])
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def member_params
    params.require(:member).permit(:first_name, :last_name, :state, :country, :city, :team_id)
  end
end
