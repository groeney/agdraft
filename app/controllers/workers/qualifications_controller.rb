class Workers::QualificationsController < Workers::BaseController
  def index
    @educations = current_worker.educations
    @certificates = current_worker.certificates
  end
end
