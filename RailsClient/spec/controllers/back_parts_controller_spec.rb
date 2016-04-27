require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe BackPartsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # BackPart. As you add validations to BackPart, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BackPartsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all back_parts as @back_parts" do
      back_part = BackPart.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:back_parts)).to eq([back_part])
    end
  end

  describe "GET #show" do
    it "assigns the requested back_part as @back_part" do
      back_part = BackPart.create! valid_attributes
      get :show, {:id => back_part.to_param}, valid_session
      expect(assigns(:back_part)).to eq(back_part)
    end
  end

  describe "GET #new" do
    it "assigns a new back_part as @back_part" do
      get :new, {}, valid_session
      expect(assigns(:back_part)).to be_a_new(BackPart)
    end
  end

  describe "GET #edit" do
    it "assigns the requested back_part as @back_part" do
      back_part = BackPart.create! valid_attributes
      get :edit, {:id => back_part.to_param}, valid_session
      expect(assigns(:back_part)).to eq(back_part)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new BackPart" do
        expect {
          post :create, {:back_part => valid_attributes}, valid_session
        }.to change(BackPart, :count).by(1)
      end

      it "assigns a newly created back_part as @back_part" do
        post :create, {:back_part => valid_attributes}, valid_session
        expect(assigns(:back_part)).to be_a(BackPart)
        expect(assigns(:back_part)).to be_persisted
      end

      it "redirects to the created back_part" do
        post :create, {:back_part => valid_attributes}, valid_session
        expect(response).to redirect_to(BackPart.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved back_part as @back_part" do
        post :create, {:back_part => invalid_attributes}, valid_session
        expect(assigns(:back_part)).to be_a_new(BackPart)
      end

      it "re-renders the 'new' template" do
        post :create, {:back_part => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested back_part" do
        back_part = BackPart.create! valid_attributes
        put :update, {:id => back_part.to_param, :back_part => new_attributes}, valid_session
        back_part.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested back_part as @back_part" do
        back_part = BackPart.create! valid_attributes
        put :update, {:id => back_part.to_param, :back_part => valid_attributes}, valid_session
        expect(assigns(:back_part)).to eq(back_part)
      end

      it "redirects to the back_part" do
        back_part = BackPart.create! valid_attributes
        put :update, {:id => back_part.to_param, :back_part => valid_attributes}, valid_session
        expect(response).to redirect_to(back_part)
      end
    end

    context "with invalid params" do
      it "assigns the back_part as @back_part" do
        back_part = BackPart.create! valid_attributes
        put :update, {:id => back_part.to_param, :back_part => invalid_attributes}, valid_session
        expect(assigns(:back_part)).to eq(back_part)
      end

      it "re-renders the 'edit' template" do
        back_part = BackPart.create! valid_attributes
        put :update, {:id => back_part.to_param, :back_part => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested back_part" do
      back_part = BackPart.create! valid_attributes
      expect {
        delete :destroy, {:id => back_part.to_param}, valid_session
      }.to change(BackPart, :count).by(-1)
    end

    it "redirects to the back_parts list" do
      back_part = BackPart.create! valid_attributes
      delete :destroy, {:id => back_part.to_param}, valid_session
      expect(response).to redirect_to(back_parts_url)
    end
  end

end
