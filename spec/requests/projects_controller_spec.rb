# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let!(:projects) { FactoryBot.create_list(:project, 10) } # assuming there's a Team factory
  let(:project)   { FactoryBot.create(:project) } # assuming there's a Team factory

  describe 'GET #index' do
    it 'assigns @projects' do
      get :index
      expect(assigns(:projects).to_a).to eq(projects.first(8))
    end

    it 'renders the index template' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template('index')
    end

    it 'returns a JSON response' do
      get :index, format: :json
      expect(response.content_type).to include('application/json')
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: project.id }
      expect(response).to render_template(:show)
    end

    it 'assigns the requested project to @project' do
      get :show, params: { id: project.id }
      expect(assigns(:project)).to eq(project)
    end

    context 'when the request format is HTML' do
      it 'returns a success response' do
        get :show, params: { id: project.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the request format is JSON' do
      it 'returns the project as JSON' do
        get :show, format: :json, params: { id: project.id }
        expect(response.content_type).to include('application/json')
        expect(response.body).to eq({
          data: {
            id: project.id.to_s,
            type: 'project',
            attributes: {
              id: project.id,
              name: project.name
            },
            relationships: {
              members: {
                data: []
              }
            }
          }
        }.to_json)

      end
    end
  end

  describe 'GET #new' do
    it 'assigns @project' do
      get :new
      expect(assigns(:project)).to be_a_new(Project)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns @project' do
      get :edit, params: { id: project.id }
      expect(assigns(:project)).to eq(project)
    end

    it 'renders the edit template' do
      get :edit, params: { id: project.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { FactoryBot.attributes_for(:project, name: 'Project name') }

      it 'creates a new project' do
        expect do
          post :create, params: { project: valid_attributes }
        end.to change(Project, :count).by(1)
      end

      it 'redirects to the new project' do
        post :create, params: { project: valid_attributes }
        expect(response).to redirect_to(Project.last)
      end

      it 'sets a flash message' do
        post :create, params: { project: valid_attributes }
        expect(flash[:success]).to eq('Project created successfully')
      end

      it 'returns a JSON response with status code 201' do
        post :create, params: { project: valid_attributes, format: :json }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { FactoryBot.attributes_for(:project, name: nil) }

      it 'does not save the new project' do
        expect do
          post :create, params: { project: invalid_attributes }
        end.not_to change(Project, :count)
      end

      it 're-renders the new method' do
        post :create, params: { project: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'returns a JSON response with errors and status code 422' do
        post :create, params: { project: invalid_attributes, format: :json }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)).to have_key('name')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the project' do
        patch :update, params: { id: project.id, project: FactoryBot.attributes_for(:project, name: 'New name') }
        project.reload
        expect(project.name).to eq('New name')
      end

      it 'redirects to the updated project' do
        patch :update, params: { id: project.id, project: FactoryBot.attributes_for(:project, name: 'New name') }
        expect(response).to redirect_to(project)
      end

      it 'returns a JSON response' do
        patch :update,
              params: { id: project.id, project: FactoryBot.attributes_for(:project, name: 'New name'), format: :json }
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the project' do
        patch :update, params: { id: project.id, project: FactoryBot.attributes_for(:project, name: nil) }
        project.reload
        expect(project.name).not_to be_nil
      end

      it 'returns a JSON response with errors and status code 422' do
        patch :update,
              params: { id: project.id, project: FactoryBot.attributes_for(:project, name: nil), format: :json }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)).to have_key('name')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the project is successfully deleted' do
      it 'redirects to the index page (html format)' do
        delete :destroy, params: { id: project.id }
        expect(response).to redirect_to(projects_path)
      end

      it 'returns a success response (json format)' do
        delete :destroy, params: { id: project.id, format: :json }
        expect(response).to have_http_status(:no_content)
      end

      it 'sets a flash success message' do
        delete :destroy, params: { id: project.id }
        expect(flash[:success]).to eq('Project deleted successfully')
      end
    end

    context 'when there is an error deleting the project' do
      before do
        allow_any_instance_of(Project).to receive(:destroy).and_raise(StandardError)
      end

      it 'redirects to the index page (html format)' do
        delete :destroy, params: { id: project.id }
        expect(response).to redirect_to(projects_path)
      end

      it 'returns an unprocessable_entity response (json format)' do
        delete :destroy, params: { id: project.id, format: :json }
        expect(response).to have_http_status(:no_content)
      end

      it 'sets a flash error message' do
        delete :destroy, params: { id: project.id }
        expect(flash[:error]).to eq('Error deleting project: StandardError')
      end
    end
  end
end
