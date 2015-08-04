json.array!(@ptl_jobs) do |ptl_job|
  json.extract! ptl_job, :id, :params, :state, :is_dirty, :is_new, :is_delete
  json.url ptl_job_url(ptl_job, format: :json)
end
