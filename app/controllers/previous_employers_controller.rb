class PreviousEmployersController < ApplicationController
  def review
    @previous_employer = PreviousEmployer.find(params[:id])
    @worker = @previous_employer.worker
  end

  def send_review
    if @previous_employer = PreviousEmployer.find(params[:id])
      AdminMailer.previous_employer_review(params[:id], params[:work_ethic], params[:communication], params[:skills], params[:recommended], params[:review]).deliver
      flash[:success] = "Thank you for sending us your feedback!"
      redirect_to root_url
    else
      @worker = @previous_employer.worker
      flash[:error] = 'Invalid Previous Employer ID'
      render 'review'
    end
  end
end