require Rails.root.join("lib/utility")
class Exports::StatisticalReportGeneratorServices < ApplicationService
  SEMESTER_TEXT_MAP = 

  def initialize(params)
    @career_id = params[:career_id]
    @year = params[:year]
    @semester = params[:semester]&.to_sym
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
      styles = {
        wrap: p.workbook.styles.add_style(alignment: {vertical: :center, wrap_text: true}),
        title_header: p.workbook.styles.add_style(:b => true, alignment: {horizontal: :center, wrap_text: true}),
        subtitle: p.workbook.styles.add_style(:bg_color => "d9d2e9", :b => true, alignment: {horizontal: :center, wrap_text: true}, :border => { :style => :thin, :color => "000000"})
      }
      p.workbook.add_worksheet(name: 'Table') do |sheet|
        title_header(sheet, styles)
        first_semester_totals = generate_semester_data(sheet, :first_semester, semester_range[:first_semester], styles: styles) if @semester.blank? || @semester == :first_semester
        sheet.add_row []
        second_semester_totals = generate_semester_data(sheet, :second_semester, semester_range[:second_semester], styles: styles) if @semester.blank? || @semester == :second_semester
        sheet.add_row

        footer(sheet, first_semester_totals, second_semester_totals, styles)
      end
    end
  end

  private

  def generate_semester_data(sheet, semester, range_date, styles: {})
    semester_data = SemesterData.new(range_date, @career_id)
    totals = {
      male_professors: 0,
      female_professors: 0,
      male_students: 0,
      female_students: 0,
      male_beneficiaries: 0,
      female_beneficiaries: 0,
      activities: semester_data.activity_weeks.count
    }
    table_headers(sheet, semester, styles)
    semester_data.activities.each do |activity|
      start_date = I18n.l(activity.start_date, format: :default)
      end_date = I18n.l(activity.end_date, format: :default)
      virtual_participation = Utility.translate_boolean(activity.virtual_participation)
      institutional_program = Utility.translate_boolean(activity.institutional_program)
      activity_quantity = semester_data.activity_weeks_by_activity[activity.id].count
      participants = semester_data.count_activity_participant_by_sex(activity)
      sheet.add_row ['Ingeniería', 'Encarnación', activity.careers.pluck(:name).join(","), activity.name, virtual_participation, activity_quantity, participants[:professor][:male], participants[:professor][:female], participants[:student][:male], participants[:student][:female], activity.beneficiary_detail.number_of_men, activity.beneficiary_detail.number_of_women, start_date + " - " + end_date, institutional_program, activity.institutional_extension_line, activity.ods_vinculation] , style: styles[:wrap]
      totals[:male_professors] += participants[:professor][:male]
      totals[:female_professors] += participants[:professor][:female]
      totals[:male_students] += participants[:student][:male]
      totals[:female_students] += participants[:student][:female]
      totals[:male_beneficiaries] += activity.beneficiary_detail.number_of_men
      totals[:female_beneficiaries] += activity.beneficiary_detail.number_of_women
    end
    sheet.add_row ['Total', '', '', '', '', totals[:activities], totals[:male_professors], totals[:female_professors], totals[:male_students], totals[:female_students], totals[:male_beneficiaries], totals[:female_beneficiaries], '', '', '', ''], style: styles[:subtitle]

    totals
  end

  def title_header(sheet, styles)
    sheet.add_row ['UNIVERSIDAD NACIONAL DE ITAPÚA'], style: styles[:title_header]
    sheet.merge_cells "A1:P1"
    sheet.add_row ['Dirección Académica- Departamento de Estadística'], style: styles[:title_header]
    sheet.merge_cells "A2:P2"
    sheet.add_row ['Rectorado'], style: styles[:title_header]
    sheet.merge_cells "A3:P3"
    sheet.add_row ['Facultad de Ingeniería'], style: styles[:title_header]
    sheet.merge_cells "A4:P4"
  end

  def table_headers(sheet, semester, styles)
    sheet.add_row [I18n.t("services.exports.statical_report_generator_services.#{semester}"), 'FORM. D.A.E N']
    sheet.add_row ['Mes/A']
    sheet.add_row ['Extensión Universitaria'], style: styles[:subtitle]
    row_index = sheet.rows.size
    sheet.merge_cells "A#{row_index}:P#{row_index}"
    sheet.add_row ['Facultad', 'Sede/Filial', 'Carrera', 'Descripción de Actividad', 'Participación Virtual', 'Cantidad de Actividades','Docentes Involucrados', '', 'Estudiantes Involucrados', '', 'Beneficiarios', '', 'Fecha', 'Programa de Extensión Institucional', 'Linea de Extensión Institucional', 'Vinculación ODS'], style: styles[:subtitle]
    sheet.add_row ['', '', '', '', '', '', 'M', 'F', 'M', 'F', 'M', 'F', '', '', '', ''], style: styles[:subtitle]
  end

  def footer(sheet, first_semester, second_semester, styles)
    sheet.add_row ['Facultad', '', 'Total Primer Semestre', 'Total Segundo Semestre'], style: styles[:subtitle]
    sheet.add_row ['Ingeniería', 'Cantidad de Actividades', '', ''], style: styles[:wrap]
    sheet.add_row ['', 'Estudiantes Involucrados', '', ''], style: styles[:wrap]
    sheet.add_row ['', 'Docentes Involucrados', '', ''], style: styles[:wrap]
    sheet.add_row ['', 'Beneficiarios', '', ''], style: styles[:wrap]
    sheet.add_row ['Suma Total:', '', '', ''], style: styles[:subtitle]
    row_index = sheet.rows.size - 4
    add_footer_totals(sheet, "C", row_index, first_semester) if first_semester
    add_footer_totals(sheet, "D", row_index, second_semester) if second_semester
  end

  def add_footer_totals(sheet, column, index, data)
    semester_students = data[:male_students] + data[:female_students]
    semester_professors = data[:male_professors] + data[:female_professors]
    semester_beneficiaries = data[:male_beneficiaries] + data[:female_beneficiaries]
    sheet["#{column}#{index}"].value = data[:activities]
    sheet["#{column}#{index + 1}"].value = semester_students
    sheet["#{column}#{index + 2}"].value = semester_professors
    sheet["#{column}#{index + 3}"].value = semester_beneficiaries
    sheet["#{column}#{index + 4}"].value = data[:activities] + semester_students + semester_professors + semester_beneficiaries
  end

  def file_name
    "Reporte_Estadistico.xlsx"
  end

  def semester_range
    @_semester_range ||= {first_semester: ["01/01/#{@year}", "31/07/#{@year}"], second_semester: ["01/08/#{@year}", "31/12/#{@year}"]}
  end

  def is_first_semester?
    @semester == :first_semester 
  end

  class SemesterData
    def initialize(range_date, career_id)
      @range_date = range_date
      @career_id = career_id
    end

    def activity_weeks
      return @activity_weeks if @activity_weeks

      @activity_weeks = ActivityWeek
        .includes(activity_week_participants: { participable: :person })
        .joins(activity: :activity_careers)
        .where("activity_weeks.end_date BETWEEN ? AND ?", @range_date[0].to_date, @range_date[1].to_date)
      @activity_weeks = @activity_weeks.joins(activity: :activity_careers).where("activity_careers.career_id = ?", @career_id) if @career_id.present?
      @activity_weeks
    end
  
    def activities
      @_activities ||= Activity.includes(:careers).joins(:activity_weeks).where(activity_weeks: {id: activity_weeks}).uniq
    end
  
    def activity_weeks_by_activity
      @_activity_weeks_by_activity ||= activity_weeks.inject({}) do |result, aw|
        result[aw.activity_id] ||= []
        result[aw.activity_id] << aw
  
        result
      end
    end
  
    def count_activity_participant_by_sex(activity)
      result = {
        professor: {
          male: 0,
          female: 0
        },
        student: {
          male: 0,
          female: 0
        }
      }.with_indifferent_access
  
      uniq_participant_ids = Set.new
      activity_weeks_by_activity[activity.id].each do |aw|
        aw.activity_week_participants.each do |awp|
          participant = awp.participable
          next unless uniq_participant_ids.add?(participant.id)
  
          result[awp.participable_type.downcase][participant.person.sex] += 1
        end
      end
  
      result
    end
  end
end