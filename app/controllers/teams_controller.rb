# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy]
  before_action :team_params, only: %i[create update]

  def index
    @teams = Team.page(params[:page]).per(8)

    respond_to do |format|
      format.html
      format.json { render json: @teams }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @team }
    end
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html do
          flash[:success] = 'Team created successfully.'
          redirect_to @team
        end
        format.json { render json: @team, status: :created }
      else
        format.html { render 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html do
          flash[:success] = 'Team updated successfully.'
          redirect_to @team
        end
        format.json { render json: @team }
      else
        format.html { render 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @team.destroy
        format.html do
          flash[:success] = 'Team deleted successfully.'
          redirect_to teams_path
        end
        format.json { head :no_content }
      else
        format.html do
          flash[:error] = 'Team not deleted successfully.'
          redirect_to teams_path
        end
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, member_ids: [])
  end
end
