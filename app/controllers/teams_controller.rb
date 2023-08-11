# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy]
  before_action :team_params, only: %i[create update]

  def index
    @teams = Team.page(params[:page]).per(8)
    serialized_data = TeamSerializer.new(@teams).serializable_hash

    respond_to do |format|
      format.html
      format.json { render json: serialized_data }
    end
  end

  def show
    serialized_data = TeamSerializer.new(@team).serializable_hash

    respond_to do |format|
      format.html
      format.json { render json: serialized_data }
    end
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      serialized_data = TeamSerializer.new(@team).serializable_hash

      respond_to do |format|
        format.html do
          flash[:success] = I18n.t('team.created_success')
          redirect_to @team
        end
        format.json { render json: serialized_data, status: :created }
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @team.update(team_params)
      serialized_data = TeamSerializer.new(@team).serializable_hash

      respond_to do |format|
        format.html do
          flash[:success] = I18n.t('team.updated_success')
          redirect_to @team
        end
        format.json { render json: serialized_data }
      end
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @team.destroy
      respond_to do |format|
        format.html do
          flash[:success] = I18n.t('team.deleted_success')
          redirect_to teams_path
        end
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = I18n.t('team.deleted_error', error: '')
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
