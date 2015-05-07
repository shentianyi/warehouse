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

RSpec.describe PartTypesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # PartType. As you add validations to PartType, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PartTypesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all part_types as @part_types" do
      part_type = PartType.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:part_types)).to eq([part_type])
    end
  end

  describe "GET show" do
    it "assigns the requested part_type as @part_type" do
      part_type = PartType.create! valid_attributes
      get :show, {:id => part_type.to_param}, valid_session
      expect(assigns(:part_type)).to eq(part_type)
    end
  end

  describe "GET new" do
    it "assigns a new part_type as @part_type" do
      get :new, {}, valid_session
      expect(assigns(:part_type)).to be_a_new(PartType)
    end
  end

  describe "GET edit" do
    it "assigns the requested part_type as @part_type" do
      part_type = PartType.create! valid_attributes
      get :edit, {:id => part_type.to_param}, valid_session
      expect(assigns(:part_type)).to eq(part_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PartType" do
        expect {
          post :create, {:part_type => valid_attributes}, valid_session
        }.to change(PartType, :count).by(1)
      end

      it "assigns a newly created part_type as @part_type" do
        post :create, {:part_type => valid_attributes}, valid_session
        expect(assigns(:part_type)).to be_a(PartType)
        expect(assigns(:part_type)).to be_persisted
      end

      it "redirects to the created part_type" do
        post :create, {:part_type => valid_attributes}, valid_session
        expect(response).to redirect_to(PartType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved part_type as @part_type" do
        post :create, {:part_type => invalid_attributes}, valid_session
        expect(assigns(:part_type)).to be_a_new(PartType)
      end

      it "re-renders the 'new' template" do
        post :create, {:part_type => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested part_type" do
        part_type = PartType.create! valid_attributes
        put :update, {:id => part_type.to_param, :part_type => new_attributes}, valid_session
        part_type.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested part_type as @part_type" do
        part_type = PartType.create! valid_attributes
        put :update, {:id => part_type.to_param, :part_type => valid_attributes}, valid_session
        expect(assigns(:part_type)).to eq(part_type)
      end

      it "redirects to the part_type" do
        part_type = PartType.create! valid_attributes
        put :update, {:id => part_type.to_param, :part_type => valid_attributes}, valid_session
        expect(response).to redirect_to(part_type)
      end
    end

    describe "with invalid params" do
      it "assigns the part_type as @part_type" do
        part_type = PartType.create! valid_attributes
        put :update, {:id => part_type.to_param, :part_type => invalid_attributes}, valid_session
        expect(assigns(:part_type)).to eq(part_type)
      end

      it "re-renders the 'edit' template" do
        part_type = PartType.create! valid_attributes
        put :update, {:id => part_type.to_param, :part_type => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested part_type" do
      part_type = PartType.create! valid_attributes
      expect {
        delete :destroy, {:id => part_type.to_param}, valid_session
      }.to change(PartType, :count).by(-1)
    end

    it "redirects to the part_types list" do
      part_type = PartType.create! valid_attributes
      delete :destroy, {:id => part_type.to_param}, valid_session
      expect(response).to redirect_to(part_types_url)
    end
  end

end
