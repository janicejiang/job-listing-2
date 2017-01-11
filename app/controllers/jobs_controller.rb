class JobsController < ApplicationController
  def index
    @jobs = Job.where(:is_hidden => false).recent
  end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "This job already archieved"
      redirect_to root_path
    end
  end
end
