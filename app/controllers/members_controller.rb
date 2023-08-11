# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :set_member, only: %i[show edit update destroy edit_team]
  before_action :set_team, only: %i[new create index]

  def index
    @members = @team.members

    respond_to do |format|
      format.html
      format.json { render json: @members }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @member }
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
          flash[:success] = 'Member created successfully.'
          redirect_to @member
        end
        format.json { render json: { message: 'Member created successfully.', member: @member }, status: :created }
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
          flash[:success] = 'Member was successfully updated.'
          redirect_to @member
        end
        format.json { render json: @member, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue StandardError => e
    respond_to do |format|
      format.html do
        redirect_to root_path, alert: "An error occurred while trying to delete the member: #{e.message}"
      end
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  def members
    @members = Member.page(params[:page]).per(8)

    respond_to do |format|
      format.html
      format.json { render json: @members }
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
