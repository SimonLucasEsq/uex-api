class Api::ActivitySubTypesController < Api::BaseController
  def index
    activity_sub_types = ActivitySubType.search(params).paginate(page: page, per_page: per_page)
    render json: activity_sub_types, each_serializer: ActivitySubTypeSerializer, meta: meta_attributes(activity_sub_types)
  end
end