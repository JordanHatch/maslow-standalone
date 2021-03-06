class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? && bot_request? }
  force_ssl if: :ssl_enabled?

  include ApplicationHelper

  acts_as_token_authentication_handler_for User, fallback: :exception, if: lambda { |controller| controller.request.format.json? }

  before_action :authenticate_user!
  check_authorization unless: :devise_controller?

  before_action :redirect_to_setup

  rescue_from ActionController::InvalidAuthenticityToken do
    render text: "Invalid authenticity token", status: 403
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to needs_path, alert: "You do not have permission to perform this action."
  end

private
  def bot_request?
    current_user.present? && current_user.bot?
  end

  def setup_enabled?
    ! User.any?
  end

  def redirect_to_setup
    redirect_to setup_path if setup_enabled?
  end

  def ssl_enabled?
    ENV['FORCE_SSL'].present?
  end

  def tag_types_with_index_pages
    @tag_types_with_index_pages ||= TagType.index_pages
  end
  helper_method :tag_types_with_index_pages
end
