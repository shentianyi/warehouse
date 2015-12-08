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

RSpec.describe OperationLogsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # OperationLog. As you add validations to OperationLog, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OperationLogsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all operation_logs as @operation_logs" do
      operation_log = OperationLog.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:operation_logs)).to eq([operation_log])
    end
  end

  describe "GET #show" do
    it "assigns the requested operation_log as @operation_log" do
      operation_log = OperationLog.create! valid_attributes
      get :show, {:id => operation_log.to_param}, valid_session
      expect(assigns(:operation_log)).to eq(operation_log)
    end
  end

  describe "GET #new" do
    it "assigns a new operation_log as @operation_log" do
      get :new, {}, valid_session
      expect(assigns(:operation_log)).to be_a_new(OperationLog)
    end
  end

  describe "GET #edit" do
    it "assigns the requested operation_log as @operation_log" do
      operation_log = OperationLog.create! valid_attributes
      get :edit, {:id => operation_log.to_param}, valid_session
      expect(assigns(:operation_log)).to eq(operation_log)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new OperationLog" do
        expect {
          post :create, {:operation_log => valid_attributes}, valid_session
        }.to change(OperationLog, :count).by(1)
      end

      it "assigns a newly created operation_log as @operation_log" do
        post :create, {:operation_log => valid_attributes}, valid_session
        expect(assigns(:operation_log)).to be_a(OperationLog)
        expect(assigns(:operation_log)).to be_persisted
      end

      it "redirects to the created operation_log" do
        post :create, {:operation_log => valid_attributes}, valid_session
        expect(response).to redirect_to(OperationLog.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved operation_log as @operation_log" do
        post :create, {:operation_log => invalid_attributes}, valid_session
        expect(assigns(:operation_log)).to be_a_new(OperationLog)
      end

      it "re-renders the 'new' template" do
        post :create, {:operation_log => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested operation_log" do
        operation_log = OperationLog.create! valid_attributes
        put :update, {:id => operation_log.to_param, :operation_log => new_attributes}, valid_session
        operation_log.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested operation_log as @operation_log" do
        operation_log = OperationLog.create! valid_attributes
        put :update, {:id => operation_log.to_param, :operation_log => valid_attributes}, valid_session
        expect(assigns(:operation_log)).to eq(operation_log)
      end

      it "redirects to the operation_log" do
        operation_log = OperationLog.create! valid_attributes
        put :update, {:id => operation_log.to_param, :operation_log => valid_attributes}, valid_session
        expect(response).to redirect_to(operation_log)
      end
    end

    context "with invalid params" do
      it "assigns the operation_log as @operation_log" do
        operation_log = OperationLog.create! valid_attributes
        put :update, {:id => operation_log.to_param, :operation_log => invalid_attributes}, valid_session
        expect(assigns(:operation_log)).to eq(operation_log)
      end

      it "re-renders the 'edit' template" do
        operation_log = OperationLog.create! valid_attributes
        put :update, {:id => operation_log.to_param, :operation_log => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested operation_log" do
      operation_log = OperationLog.create! valid_attributes
      expect {
        delete :destroy, {:id => operation_log.to_param}, valid_session
      }.to change(OperationLog, :count).by(-1)
    end

    it "redirects to the operation_logs list" do
      operation_log = OperationLog.create! valid_attributes
      delete :destroy, {:id => operation_log.to_param}, valid_session
      expect(response).to redirect_to(operation_logs_url)
    end
  end

end
