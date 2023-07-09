class Api::BaseController < ApplicationController
  before_action :authorize_access_request!

  MAX_PER_PAGE = 100
  DEFAULT_PER_PAGE = 10

  private
  def per_page
    (params[:per_page].blank? || params[:per_page].to_i > MAX_PER_PAGE) ? DEFAULT_PER_PAGE : params[:per_page].to_i
  end

  def page
    params[:page] || 1
  end

  def meta_attributes(record)
    { 
      per_page: per_page,
      total_pages: record.total_pages,
      total_objects: record.total_entries
    }
  end
end
