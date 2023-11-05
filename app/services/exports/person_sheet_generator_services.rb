class Exports::PersonSheetGeneratorServices < ApplicationService
  ALLOWED_ENTITY_TYPES = [Professor, Student]
  CATEGORY_MAP = {
    professor: "docente",
    student: "estudiante"
  }

  def initialize(entity)
    @entity = entity
  end

  def call
    super

    {
      data_stream: generate_xlsx_file.to_stream(), 
      filename: file_name
    }
  end

  def generate_xlsx_file
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: 'Table') do |sheet|
        sheet.add_row ['A - IDENTIFICACIÓN PERSONAL']
        sheet.add_row ['1 NOMBRES Y APELLIDOS:', @entity.full_name]
        sheet.add_row ['2 No C.I.:', @entity.id_card.to_s]
        sheet.add_row ['3 CARRERA:', @entity.career_formatter]
        sheet.add_row ['4 CATEGORIA (docente o estudiante):', category]
        sheet.add_row ['5 AÑO DE INGRESO:', @entity.respond_to?(:admission_year) ? @entity.admission_year : nil]
        sheet.add_row ['6 CORREO ELECTRONICO:', @entity.email]
        sheet.add_row ['7 CELULAR:', @entity.phone_number]
  
        sheet.add_row ['B - ACTIVIDADES DE EXTENSIÓN UNIVERSITARIA']
        sheet.add_row ['No', 'DENOMINACIÓN DE ACTIVIDAD', 'TIPO DE ACTIVIDAD', 'RESPONSABLE', 'FECHA', 'LUGAR', 'HORAS DE EXTENSIÓN', 'EVALUACIÓN']

        index = 1
        activities.each do |activity|
          activity_week_participants = activity_week_participants_by_activities[activity.id]

          if activity_week_participants
            activity_week_participants.each do |awp|
              hours = awp.hours if awp.student?
              evaluation = awp.evaluation if awp.student?
              sheet.add_row [index, activity.name, awp.activity_sub_type.name, activity.professor.full_name, awp.activity_week.date_formatted, activity.address, hours, evaluation]
              index += 1
            end
          else
            activity.activity_sub_types.each do |activity_sub_type|
              sheet.add_row [index, activity.name, activity_sub_type.name, activity.professor.full_name, activity.date_formatted, activity.address, "", ""]
              index += 1
            end
          end
        end
      end
    end
  end

  private

  def category
    CATEGORY_MAP[@entity.class.to_s.downcase.to_sym]
  end

  def activities
    return @activities if @activities

    @activities = Activity
      .includes(:professor, :activity_sub_types)
      .where(id: activity_week_participants.map { |awp| awp.activity_week.activity_id }.uniq)
    @activities = @activities.or(Activity.where(professor_id: @entity)) if professor?
    @activities = @activities.uniq
  end

  def professor?
    @professor ||= @entity.is_a?(Professor)
  end

  def activity_week_participants_by_activities
    @activity_week_participants_by_activities ||= activity_week_participants.group_by { |awp| awp.activity_week.activity_id }
  end

  def activity_week_participants
    @activity_week_participants ||= @entity.activity_week_participants.includes(:activity_week)
  end

  def validate_params!
    raise "Missing entity" unless @entity
    raise "Invalid entity type #{@entity.class}" unless ALLOWED_ENTITY_TYPES.include?(@entity.class)
  end

  def file_name
    "Ficha_#{@entity.person.first_name}_#{@entity.person.last_name}.xlsx"
  end
end
