class Admin::JobsController < ApplicationController
  before_action :require_is_admin

  def index
    @jobs = Job.all
  end

end
