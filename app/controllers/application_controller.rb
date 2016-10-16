class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound do
    render_404
  end

  rescue_from ActiveRecord::RecordNotUnique do
    render_400
  end

  rescue_from ActiveRecord::InvalidForeignKey do
    render_400
  end

  rescue_from ActionController::ParameterMissing do
    render_400
  end

  protected

  def devise_parameter_sanitizer
    if resource_class == Worker
      Worker::ParameterSanitizer.new(Worker, :worker, params)
    elsif resource_class == Farmer
      Farmer::ParameterSanitizer.new(Farmer, :farmer, params)
    else
      super # Use the default one
    end
  end

  def render_409
    respond_to do |format|
      format.json {
        render json: { error: "409 conflict found in requested action." }.to_json, status: 409
      }
    end
  end

  def render_404
    respond_to do |format|
      format.json {
        render json: { error: "404 not-found" }.to_json, status: 404
      }
      format.html{
        render :file => "public/404.html", status: :not_found, layout: false
      }
    end
  end

  def render_401(message)
    respond_to do |format|
      format.json {
        render json: { error: message }.to_json, status: 401
      }
      format.html{
        render :file => "public/422.html", status: 401, layout: false
      }
    end
  end

  def render_400
    respond_to do |format|
      format.json {
        render json: { error: "400 client sent a poorly formed request" }.to_json, status: 400
      }
      format.html{
        render :file => "public/422.html", status: 400, layout: false
      }
    end
  end

  def render_201
    respond_to do |format|
      format.json {
        render json: { message: "Created resource!" }.to_json, status: 201
      }
    end
  end

  def render_204
    respond_to do |format|
      format.json {
        render json: {}, status: 204
      }
    end
  end
end
