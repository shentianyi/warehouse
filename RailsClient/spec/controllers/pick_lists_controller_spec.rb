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

RSpec.describe PickListsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # PickList. As you add validations to PickList, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PickListsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all pick_lists as @pick_lists" do
      pick_list = PickList.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:pick_lists)).to eq([pick_list])
    end
  end

  describe "GET show" do
    it "assigns the requested pick_list as @pick_list" do
      pick_list = PickList.create! valid_attributes
      get :show, {:id => pick_list.to_param}, valid_session
      expect(assigns(:pick_list)).to eq(pick_list)
    end
  end

  describe "GET new" do
    it "assigns a new pick_list as @pick_list" do
      get :new, {}, valid_session
      expect(assigns(:pick_list)).to be_a_new(PickList)
    end
  end

  describe "GET edit" do
    it "assigns the requested pick_list as @pick_list" do
      pick_list = PickList.create! valid_attributes
      get :edit, {:id => pick_list.to_param}, valid_session
      expect(assigns(:pick_list)).to eq(pick_list)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PickList" do
        expect {
          post :create, {:pick_list => valid_attributes}, valid_session
        }.to change(PickList, :count).by(1)
      end

      it "assigns a newly created pick_list as @pick_list" do
        post :create, {:pick_list => valid_attributes}, valid_session
        expect(assigns(:pick_list)).to be_a(PickList)
        expect(assigns(:pick_list)).to be_persisted
      end

      it "redirects to the created pick_list" do
        post :create, {:pick_list => valid_attributes}, valid_session
        expect(response).to redirect_to(PickList.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved pick_list as @pick_list" do
        post :create, {:pick_list => invalid_attributes}, valid_session
        expect(assigns(:pick_list)).to be_a_new(PickList)
      end

      it "re-renders the 'new' template" do
        post :create, {:pick_list => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested pick_list" do
        pick_list = PickList.create! valid_attributes
        put :update, {:id => pick_list.to_param, :pick_list => new_attributes}, valid_session
        pick_list.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested pick_list as @pick_list" do
        pick_list = PickList.create! valid_attributes
        put :update, {:id => pick_list.to_param, :pick_list => valid_attributes}, valid_session
        expect(assigns(:pick_list)).to eq(pick_list)
      end

      it "redirects to the pick_list" do
        pick_list = PickList.create! valid_attributes
        put :update, {:id => pick_list.to_param, :pick_list => valid_attributes}, valid_session
        expect(response).to redirect_to(pick_list)
      end
    end

    describe "with invalid params" do
      it "assigns the pick_list as @pick_list" do
        pick_list = PickList.create! valid_attributes
        put :update, {:id => pick_list.to_param, :pick_list => invalid_attributes}, valid_session
        expect(assigns(:pick_list)).to eq(pick_list)
      end

      it "re-renders the 'edit' template" do
        pick_list = PickList.create! valid_attributes
        put :update, {:id => pick_list.to_param, :pick_list => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested pick_list" do
      pick_list = PickList.create! valid_attributes
      expect {
        delete :destroy, {:id => pick_list.to_param}, valid_session
      }.to change(PickList, :count).by(-1)
    end

    it "redirects to the pick_lists list" do
      pick_list = PickList.create! valid_attributes
      delete :destroy, {:id => pick_list.to_param}, valid_session
      expect(response).to redirect_to(pick_lists_url)
    end
  end

end
