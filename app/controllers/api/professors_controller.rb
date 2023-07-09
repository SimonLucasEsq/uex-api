class Api::ProfessorsController < Api::BaseController
  before_action :set_professor, only: [:create, :show, :update, :destroy, :export_professor_data]

  def create
    @professor.save!
    render json: @professor
  end

  def index
    professors = Professor.includes(:person, professor_careers: :career).search(params).paginate(page: page, per_page: per_page)
    render json: professors, each_serializer: ProfessorSerializer, meta: meta_attributes(professors)
  end

  def show
    render json: @professor
  end

  def update
    @professor.update!(professor_params)
    render json: @professor
  end

  def destroy
    @professor.destroy!
  end

  def import_csv
    professor_csv = Imports::ProfessorCsv.new(params[:file])
    result = professor_csv.import
    render json: { message: result }, status: :ok
  end

  def export_professor_data
    result = Exports::PersonSheetGeneratorServices.call(@professor)

    send_data(
      result[:data_stream],
      filename: result[:filename],
      disposition: 'attachment',
    )
  end

  private

  def set_professor
    @professor = if params[:id]
      Professor.includes(:person, professor_careers: :career).find(params[:id])
    else
      Professor.new(professor_params)
    end
  end

  def professor_params
    params[:professor][:person_attributes] = params[:professor].delete(:person)
    params[:professor][:professor_careers_attributes] = params[:professor].delete(:professor_careers)
    params.require(:professor).permit(
      person_attributes: [:id, :name, :first_name, :last_name, :email, :phone_number, :id_card, :address, :sex],
      professor_careers_attributes: [:id, :career_id, :_destroy]
    )
  end
end
