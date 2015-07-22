class PtlJobsController < ApplicationController
  before_action :set_ptl_job, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @ptl_jobs = PtlJob.all
    respond_with(@ptl_jobs)
  end

  def show
    respond_with(@ptl_job)
  end

  def new
    @ptl_job = PtlJob.new
    respond_with(@ptl_job)
  end

  def edit
  end

  def create
    @ptl_job = PtlJob.new(ptl_job_params)
    @ptl_job.save
    respond_with(@ptl_job)
  end

  def update
    @ptl_job.update(ptl_job_params)
    respond_with(@ptl_job)
  end

  def destroy
    @ptl_job.destroy
    respond_with(@ptl_job)
  end

  private
    def set_ptl_job
      @ptl_job = PtlJob.find(params[:id])
    end

    def ptl_job_params
      params.require(:ptl_job).permit(:params, :state, :is_dirty, :is_new, :is_delete)
    end
end
