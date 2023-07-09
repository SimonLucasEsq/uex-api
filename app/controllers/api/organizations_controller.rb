class Api::OrganizationsController < Api::BaseController
  before_action :set_organization, only: [:create, :show, :update, :destroy]

  def create
    @organization.save!
    render json: @organization
  end

  def index
    organizations = Organization.search(params).paginate(page: page, per_page: per_page)
    render json: organizations, each_serializer: OrganizationSerializer, meta: meta_attributes(organizations)
  end

  def show
    render json: @organization
  end

  def update
    @organization.update!(organization_params)
    render json: @organization
  end

  def destroy
    @organization.destroy!
  end

  private
  def set_organization
    @organization = if params[:id]
      Organization.find(params[:id])
    else
      Organization.new(organization_params)
    end
  end

  def organization_params
    params.require(:organization).permit(:name, :address, :current_agreement, :contact_name, :contact_email, :contact_phonenumber)
  end
end
