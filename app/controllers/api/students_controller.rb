class Api::StudentsController < Api::BaseController
  before_action :set_student, only: [:create, :show, :update, :destroy, :export_student_data, :update_status]

  def create
    @student.save!
    render json: @student
  end

  def index
    students = Student.includes(:person).search(params).paginate(page: page, per_page: per_page)
    render json: students, each_serializer: StudentSerializer, meta: meta_attributes(students)
  end

  def show
    render json: @student
  end

  def update
    @student.update!(student_params)
    render json: @student
  end

  def destroy
    @student.destroy!
  end

  def import_csv
    student_csv = Imports::StudentCsv.new(params[:file])
    result = student_csv.import
    render json: { message: result }, status: :ok
  end

  def export_student_data
    result = Exports::PersonSheetGeneratorServices.call(@student)

    send_data(
      result[:data_stream],
      filename: result[:filename],
      disposition: 'attachment',
    )
  end

  def update_status
    result = Models::UpdateStudentStatusServices.call(@student, params[:status])

    render json: result
  end

  private
  def set_student
    @student = if params[:id]
      Student.includes(:person).find(params[:id])
    else
      Student.new(student_params)
    end
  end

  def student_params
    params[:student][:person_attributes] = params[:student].delete(:person)
    params.require(:student).permit(:id, :hours, :submitted, :admission_year, :career_id,
      person_attributes: [:id, :name, :first_name, :last_name, :email, :phone_number, :id_card, :address, :sex])
  end
end
