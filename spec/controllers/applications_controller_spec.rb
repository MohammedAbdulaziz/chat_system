require 'rails_helper'

RSpec.describe ApplicationsController, type: :controller do
  let(:valid_attributes) { { name: "New Application" } }
  let(:invalid_attributes) { { name: "" } }
  let!(:application) { create(:application) }

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Application" do
        expect {
          post :create, params: { application: valid_attributes }
        }.to change(Application, :count).by(1)
      end

      it "renders a JSON response with the new application" do
        post :create, params: { application: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the new application" do
        post :create, params: { application: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "Updated Application" } }

      it "updates the requested application" do
        put :update, params: { application_token: application.token, application: new_attributes }
        application.reload
        expect(application.name).to eq("Updated Application")
      end

      it "renders a JSON response with the application" do
        put :update, params: { application_token: application.token, application: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the application" do
        put :update, params: { application_token: application.token, application: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "GET #show" do
    context "when application exists" do
      it "returns the application" do
        get :show, params: { application_token: application.token }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "when application does not exist" do
      it "returns a not found status" do
        get :show, params: { application_token: "invalid_token" }
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
