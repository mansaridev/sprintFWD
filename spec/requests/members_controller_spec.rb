# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  let(:team)     { FactoryBot.create(:team) }
  let(:member)   { FactoryBot.create(:member, team: team) }
  let!(:member1) { FactoryBot.create(:member, team: team) }
  let!(:member2) { FactoryBot.create(:member, team: team) }

  describe 'GET #index' do
    context 'when requesting HTML format' do
      it 'assigns @members' do
        get :index, params: { team_id: team.id }
        expect(assigns(:members)).to match_array([member1, member2])
      end

      it 'renders the index template' do
        get :index, params: { team_id: team.id }
        expect(response).to render_template :index
      end
    end

    context 'when requesting JSON format' do
      it 'assigns @members' do
        get :index, params: { team_id: team.id }, format: :json

        expect(assigns(:members)).to match_array([member1, member2])
      end

      it 'returns the members as JSON' do
        get :index, params: { team_id: team.id }, format: :json

        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
        expect(json_response[0]['first_name']).to eq(member1.first_name)
        expect(json_response[1]['first_name']).to eq(member2.first_name)
        expect(json_response[0]['last_name']).to eq(member1.last_name)
        expect(json_response[1]['last_name']).to eq(member2.last_name)
      end
    end
  end

  describe '#show' do
    context 'when the request is for HTML format' do
      it "renders the 'show' template" do
        get :show, params: { id: member.id }
        expect(response).to render_template('show')
      end
    end

    context 'when the request is for JSON format' do
      it 'renders the member as JSON' do
        get :show, params: { id: member.id }, format: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(member.as_json)
      end
    end
  end

  describe '#new' do
    it 'assigns a new Member to @member' do
      get :new, params: { team_id: team.id }
      expect(assigns(:member)).to be_a_new(Member)
    end

    it 'builds the member for the specified team' do
      get :new, params: { team_id: team.id }
      expect(assigns(:member).team).to eq(team)
    end
  end

  describe '#edit' do
    it 'assigns the requested Member to @member' do
      get :edit, params: { id: member.id }
      expect(assigns(:member)).to eq(member)
    end

    it "renders the 'edit' template" do
      get :edit, params: { id: member.id }
      expect(response).to render_template('edit')
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:member_params) { FactoryBot.attributes_for(:member, team_id: team.id) }

      it 'creates a new member' do
        expect do
          post :create, params: { team_id: team.id, member: member_params }
        end.to change(Member, :count).by(1)
      end

      it 'redirects to the new member' do
        post :create, params: { team_id: team.id, member: member_params }
        expect(response).to redirect_to(Member.last)
      end

      it 'sets a flash success message' do
        post :create, params: { team_id: team.id, member: member_params }
        expect(flash[:success]).to eq('Member created successfully.')
      end

      it 'returns JSON with a success message and the new member' do
        post :create, params: { team_id: team.id, member: member_params }, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Member created successfully.')
        expect(json_response['member']['first_name']).to eq(member_params[:first_name])
        expect(json_response['member']['last_name']).to eq(member_params[:last_name])
      end
    end

    context 'with invalid parameters' do
      let(:member_params) { FactoryBot.attributes_for(:member, first_name: nil, team_id: team.id) }

      it 'does not create a new member' do
        expect do
          post :create, params: { team_id: team.id, member: member_params }
        end.not_to change(Member, :count)
      end

      it 'renders the new template' do
        post :create, params: { team_id: team.id, member: member_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#update' do
    context 'with valid attributes' do
      let(:valid_params) { FactoryBot.attributes_for(:member, first_name: 'New', last_name: 'Name') }

      it 'updates the member and redirects to the member page' do
        put :update, params: { id: member.id, member: valid_params }
        expect(response).to redirect_to(member)
        expect(flash[:success]).to eq('Member was successfully updated.')
        member.reload
        expect(member.first_name).to eq('New')
        expect(member.last_name).to eq('Name')
      end

      it 'returns the updated member in JSON format' do
        put :update, params: { id: member.id, member: valid_params, format: 'json' }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)['first_name']).to eq('New')
        expect(JSON.parse(response.body)['last_name']).to eq('Name')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) { FactoryBot.attributes_for(:member, first_name: '', last_name: '') }

      it 'does not update the member and re-renders the edit form' do
        put :update, params: { id: member.id, member: invalid_params }
        expect(response).to render_template(:edit)
        expect(assigns(:member).errors).not_to be_empty
      end

      it 'returns the member errors in JSON format' do
        put :update, params: { id: member.id, member: invalid_params, format: 'json' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)['first_name']).to include("can't be blank")
        expect(JSON.parse(response.body)['last_name']).to include("can't be blank")
      end
    end
  end

  describe '#destroy' do
    it 'destroys the member and redirects to the root page' do
      delete :destroy, params: { id: member.id }

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Member was successfully destroyed.')
    end

    it 'returns a no content response in JSON format' do
      delete :destroy, params: { id: member.id, format: 'json' }

      expect(response).to have_http_status(:no_content)
    end
  end

  describe '#members' do
    context 'when the request is for HTML format' do
      it 'assigns the paginated members to @members' do
        get :members
        expect(assigns(:members)).to be_present
        expect(assigns(:members)).to be_a(ActiveRecord::Relation)
      end

      it "renders the 'members' template" do
        get :members
        expect(response).to render_template('members')
      end
    end

    context 'when the request is for JSON format' do
      it 'assigns the paginated members to @members' do
        get :members, format: :json
        expect(assigns(:members)).to be_present
        expect(assigns(:members)).to be_a(ActiveRecord::Relation)
      end

      it 'renders the members as JSON' do
        get :members, format: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_a(Array)
      end
    end
  end

  describe '#edit_team' do
    it "renders the 'edit_team' template" do
      get :edit_team, params: { member_id: member.id }
      expect(response).to render_template('edit_team')
    end
  end
end
