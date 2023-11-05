# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create login user
User.create(email: "diep@fiuni.edu.py", password: "QueLindoSistemaUEX", username: "Admin")
User.create(email: "diep+001@fiuni.edu.py", password: "QueLindoUEX2", username: "Secretaria")

Career.create([{name: "Ingeniería Civil"}, {name: "Ingeniería Electromecánica"}, {name: "Ingeniería Informática"}])

ActivityType.create(
  [
    {
      name: "Cursos extracurriculares",
      description: "Cursos de formación y capacitación para estudiantes, docentes, investigadores, y funcionarios.",
      activity_sub_types_attributes: [
        {name: "Programas de formación, capacitación y actualización a la comunidad", hours: 10, unlimited_hours: false},
        {name: "Charlas educativas de interés social y estudiantil", hours: 10, unlimited_hours: false},
        {name: "Campañas de concienciación", hours: 10, unlimited_hours: false}
      ]
    },
    {
      name: "Prestaciones de servicios",
      description: "Actividades de servicios propias a las carreras de la Facultad, o dentro de una asignatura, por los estudiantes, con orientación del jefe de cátedra.",
      activity_sub_types_attributes: [
        {name: "Servicios a la comunidad educativa, instituciones y sociedad general, bolsa de trabajo", hours: 20, unlimited_hours: false},
        {name: "Actividades de laboratorio", hours: 20, unlimited_hours: false}
      ]
    },
    {
      name: "Asesorías a la comunidad",
      description: "Actividades destinadas a proyectar a la sociedad el saber científico y técnico acumulado en el conocimiento o la experiencia universitaria.",
      activity_sub_types_attributes: [
        {name: "Consultoría", hours: 20, unlimited_hours: false},
        {name: "Asistencia técnica", hours: 20, unlimited_hours: false}
      ]
    },
    {
      name: "Publicaciones",
      description: "Transmisión de resultados y artículos académicos publicados en revistas, periódicos, páginas web u otros, a nivel nacional e internacional.",
      activity_sub_types_attributes: [
        {name: "Impresos: Artículos académicos publicados en periódicos y revistas", hours: 20, unlimited_hours: false},
        {name: "Transmisiones electrónicas: artículos académicos publicados en páginas web u otros", hours: 20, unlimited_hours: false}
      ]
    },
    {
      name: "Eventos académicos",
      description: "Para la actualización de estudiantes, docentes, egresados y público en general (congresos, seminarios, foros, paneles, conferencias, exposiciones, simposios, etc.), nacional e internacional.",
      activity_sub_types_attributes: [
        {name: "Como expositor", hours: 15, unlimited_hours: false},
        {name: "Como participante", hours: 8, unlimited_hours: false},
        {name: "Como organizador o voluntario", hours: 15, unlimited_hours: false}
      ]
    },
    {
      name: "Adquisición de experiencias y conocimientos",
      description: "Prácticas de los estudiantes en su área de estudio a través de observaciones estructuradas y trabajo de campo.",
      activity_sub_types_attributes: [
        {name: "Trabajos de Campo (censos, entrevistas, encuestas)", hours: 10, unlimited_hours: false},
        {name: "Viajes de Estudio (charlas sobre intercambios realizados)", hours: 8, unlimited_hours: false},
        {name: "Participación en visitas técnicas, educativas", hours: 10, unlimited_hours: false}
      ]
    },
    {
      name: "Promoción",
      description: "Promoción de carreras: se refiere a las actividades que dan a conocer a la sociedad las carreras ofrecidas por la Facultad.",
      activity_sub_types_attributes: [
        {name: "Promoción de carreras", hours: 10, unlimited_hours: false},
        {name: "Otras promociones", hours: 8, unlimited_hours: false}
      ]
    },
    {
      name: "Actividades culturales",
      description: "Actividades organizadas o en las que participa la facultad relacionadas con la música, teatro, danza, idioma, festivales, conciertos y otros.",
      activity_sub_types_attributes: [
        {name: "Música, teatro, danza, idiomas, festivales, conciertos y otros", hours: 10, unlimited_hours: false}
      ]
    },
    {
      name: "Deportes",
      description: "Campeonatos, torneos, juegos internos, prácticas y otros.",
      activity_sub_types_attributes: [
        {name: "Participación como jugador", hours: 10, unlimited_hours: false}
      ]
    }
  ])

Organization.create({name: "Facultad de Ingeniería", address: "Encarnacion", current_agreement: true, contact_name: "Oscar Tróchez"})