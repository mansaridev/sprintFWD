# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = Project.page(params[:page]).per(8)

    respond_to do |format|
      format.html
      format.json { render json: @projects }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @project }
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html do
          flash[:success] = 'Project created successfully'
          redirect_to @project
        end
        format.json { render json: @project, status: :created }
      else
        format.html { render 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html do
          flash[:success] = 'Project updated successfully'
          redirect_to @project
        end
        format.json { render json: @project, status: :ok }
      else
        format.html do
          flash[:error] = 'Failed to update project'
          render :edit
        end
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      @project.destroy
      flash[:success] = 'Project deleted successfully'
    rescue StandardError => e
      flash[:error] = "Error deleting project: #{e.message}"
    end
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, member_ids: [])
  end
end
