# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy project_members]

  def index
    @projects = Project.page(params[:page]).per(8)

    respond_to do |format|
      format.html
      format.json { render json: ProjectSerializer.new(@projects) }
    end
  end

  def project_members
    @members = @project.members
    render json: MemberSerializer.new(@members)
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: ProjectSerializer.new(@project) }
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
          flash[:success] = I18n.t('project.created_successfully')
          redirect_to @project
        end
        format.json { render json: ProjectSerializer.new(@project), status: :created }
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
          flash[:success] = I18n.t('project.updated_successfully')
          redirect_to @project
        end
        format.json { render json: ProjectSerializer.new(@project), status: :ok }
      else
        format.html do
          render :edit
        end
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      @project.destroy
      flash[:success] = I18n.t('project.deleted_successfully')
    rescue StandardError => e
      flash[:error] = I18n.t('project.deletion_error', error: e.message)
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
