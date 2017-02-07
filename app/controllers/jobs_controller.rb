class JobsController < ApplicationController
  def annotate
  	@key = params[:key]

  	@job_to_annotate = Job.find_by_id(params[:id])

  	@sov_annotation = Annotation.find_by(user: "sovereign", job_id: @job_to_annotate.id)

  	@nextJobId = params[:id].to_i + 1
  end
end
