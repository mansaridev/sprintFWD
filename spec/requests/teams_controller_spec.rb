# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let!(:teams) { FactoryBot.create_list(:team, 10) } # assuming there's a Team factory
  let(:team)   { FactoryBot.create(:team) } # assuming there's a Team factory

  describe 'GET #index' do
    it 'assigns @teams' do
      get :index
      expect(assigns(:teams).to_a).to eq(teams.first(8))
    end

    it 'returns 8 teams per page' do
      get :index
      expect(assigns(:teams).count).to eq(8)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'returns JSON' do
      get :index, format: :json
      expect(response.content_type).to include('application/json')
    end
  end

  describe 'GET #show' do
    context 'when requesting HTML format' do
      it "renders the 'show' template" do
        get :show, params: { id: team.id }
        expect(response).to render_template(:show)
      end
    end

    context 'when requesting JSON format' do
      it 'returns the team as JSON' do
        get :show, params: { id: team.id }, format: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response.body).to eq(team.to_json)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns @team' do
      get :new
      expect(assigns(:team)).to be_a_new(Team)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns @team' do
      get :edit, params: { id: team.id }
      expect(assigns(:team)).to eq(team)
    end

    it 'renders the edit template' do
      get :edit, params: { id: team.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { FactoryBot.attributes_for(:team, name: 'New Team') }

      it 'creates a new team' do
        expect do
          post :create, params: { team: valid_attributes }
        end.to change(Team, :count).by(1)
      end

      it "redirects to the team's page" do
        post :create, params: { team: valid_attributes }
        expect(response).to redirect_to(assigns(:team))
      end

      it 'sets a success flash message' do
        post :create, params: { team: valid_attributes }
        expect(flash[:success]).to eq('Team created successfully.')
      end

      it 'returns JSON' do
        post :create, params: { team: valid_attributes }, format: :json
        expect(response.content_type).to include('application/json')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { FactoryBot.attributes_for(:team, name: nil) }

      it 'does not create a new team' do
        expect do
          post :create, params: { team: invalid_attributes }
        end.to_not change(Team, :count)
      end

      it 'renders the new template' do
        post :create, params: { team: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'returns JSON with error status' do
        post :create, params: { team: invalid_attributes }, format: :json
        expect(response.content_type).to include('application/json')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      let(:valid_attributes) { FactoryBot.attributes_for(:team, name: 'New Name') }

      it 'updates the team' do
        put :update, params: { id: team.id, team: valid_attributes }
        expect(team.reload.name).to eq('New Name')
      end

      it 'redirects to the updated team' do
        put :update, params: { id: team.id, team: valid_attributes }
        expect(response).to redirect_to(team)
      end

      it 'returns JSON' do
        put :update, params: { id: team.id, team: valid_attributes }, format: :json
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { FactoryBot.attributes_for(:team, name: '') }

      it 'does not update the team' do
        put :update, params: { id: team.id, team: invalid_attributes }
        expect(team.reload.name).to_not eq('')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the team is successfully deleted' do
      it 'redirects to the teams index page' do
        delete :destroy, params: { id: team.id }
        expect(response).to redirect_to(teams_path)
      end

      it 'sets a success flash message' do
        delete :destroy, params: { id: team.id }
        expect(flash[:success]).to eq('Team deleted successfully.')
      end

      it 'returns a no content response in JSON format' do
        delete :destroy, params: { id: team.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the team fails to delete' do
      before do
        allow_any_instance_of(Team).to receive(:destroy).and_return(false)
      end

      it 'redirects to the teams index page' do
        delete :destroy, params: { id: team.id }
        expect(response).to redirect_to(teams_path)
      end

      it 'sets an error flash message' do
        delete :destroy, params: { id: team.id }
        expect(flash[:error]).to eq('Team not deleted successfully.')
      end

      it 'returns a JSON response with errors' do
        delete :destroy, params: { id: team.id }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end
end
