class Exports::ProjectListReportGeneratorServices < ApplicationService

  def initialize(params)
    @start_date = params[:approved_at_start]&.to_date
    @end_date = params[:approved_at_end]&.to_date

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
        sheet.add_row ['Proyecto', 'Resolución', 'Fecha de Aprobación', 'Fecha de culminación según cronograma', 'Estudiantes', 'Objetivos', 'Coordinador', 'Estado', 'Informe']

        index = 1
        activities = Activity.where("approved_at >= ? and approved_at <= ? ", @start_date, @end_date ).includes(activity_weeks: { activity_week_participants: {participable: :person}})
        activities.each do |activity|
          approved_at = I18n.l(activity.approved_at, format: :default)
          end_date = I18n.l(activity.end_date, format: :default)
          wrap = p.workbook.styles.add_style alignment: {vertical: :center, wrap_text: true}
          sheet.add_row [activity.name, activity.resolution_number, approved_at, end_date, participants(activity), activity.objective, activity.professor.full_name, activity.status, ""] , style: wrap
        end
      end
    end
  end

  private

  def participants(activity)
    participants = {}
    activity.activity_weeks.each do |aw|
      aw.activity_week_participants.each do |awp|
        person = awp.participable.person
        participants[person.id] = person.full_name
      end
    end
    participants.values.join("/r")
  end

  def file_name
    "Listado_de_Proyectos.xlsx"
  end

end
