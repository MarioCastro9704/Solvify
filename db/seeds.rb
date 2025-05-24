require_relative '../app/services/daily_service'

puts "Iniciando proceso de seeds..."

# Usamos un bloque de transacción para mejorar el rendimiento
ActiveRecord::Base.transaction do
  # Eliminación de registros existentes en orden para evitar problemas de llaves foráneas
  puts "Eliminando registros existentes..."
  PaymentStatus.destroy_all
  Review.destroy_all
  Message.destroy_all
  Booking.destroy_all
  Availability.destroy_all
  Service.destroy_all
  Psychologist.destroy_all
  User.destroy_all
  
  # Limpieza de salas de videollamada existentes
  begin
    puts "Limpiando salas de video..."
    daily_service = DailyService.new('afd0d96efeb72db1d03e5c1618aaa78a35e2ecac1cd249b411ce2196ceddae26')
    daily_service.delete_all_rooms
  rescue => e
    puts "Error al limpiar salas de video: #{e.message}"
  end

# Creación de Usuarios
users = []
users << User.create!(
  name: "Ana",
  last_name: "García",
  email: "ana.garcia@example.com",
  password: 'password',
  date_of_birth: "1985-05-23",
  gender: "Femenino",
  address: "Calle Falsa 123, Ciudad",
  nationality: "Argentina"
)

2.times do
  gender = ['Femenino', 'Masculino'].sample
  first_name = gender == 'Masculino' ? Faker::Name.male_first_name : Faker::Name.female_first_name

  nationality = Faker::Nation.nationality
  users << User.create!(
    name: first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    password: 'password',
    date_of_birth: Faker::Date.birthday(min_age: 25, max_age: 70),
    gender: gender,
    address: Faker::Address.full_address,
    nationality: nationality
  )
end

# Create Psychologists
psychologists = []
psychologists << User.create!(
  name: "Dr. Pedro",
  last_name: "Ramírez",
  email: "pedro.ramirez@example.com",
  password: 'password',
  date_of_birth: "1975-03-20",
  gender: "Masculino",
  address: "Calle Psicología 123, Ciudad",
  nationality: "España"
).create_psychologist!(
  degree: "Licenciatura en Psicología",
  document_of_identity: "DNI12345678",
  price_per_hour: 70,
  approach: "Cognitivo-Conductual",
  languages: "Español, Inglés",
  nationality: "España",
  currency: "EUR",
  specialty: "Terapia Cognitivo-Conductual",
  specialties: ["Terapia Cognitivo-Conductual", "Psicoanálisis"]
)

15.times do
  gender = ['Femenino', 'Masculino'].sample
  title = gender == 'Masculino' ? 'Dr.' : 'Dra.'
  first_name = gender == 'Masculino' ? Faker::Name.male_first_name : Faker::Name.female_first_name

  nationality_currency = {
    "Argentina" => "ARS",
    "España" => "EUR",
    "México" => "MXN",
    "Chile" => "CLP",
    "Perú" => "PEN"
  }
  nationality = nationality_currency.keys.sample
  currency = nationality_currency[nationality]

  psychologist_user = User.create!(
    name: "#{title} #{first_name}",
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    password: 'password',
    date_of_birth: Faker::Date.birthday(min_age: 25, max_age: 70),
    gender: gender,
    address: Faker::Address.full_address,
    nationality: nationality
  )
  psychologists << psychologist_user.create_psychologist!(
    degree: "Licenciatura en Psicología",
    document_of_identity: "DNI#{Faker::Number.unique.number(digits: 8)}",
    price_per_hour: rand(50..120),
    approach: ['Cognitivo-Conductual', 'Psicoanálisis', 'Terapia Familiar', 'Neuropsicología'].sample,
    languages: ['Español', 'Inglés', 'Francés', 'Alemán'].sample(rand(1..4)).join(', '),
    nationality: psychologist_user.nationality,
    currency: currency,
    specialty: ['Terapia Cognitivo-Conductual', 'Psicoanálisis', 'Terapia Familiar', 'Psicología Organizacional', 'Terapia de Pareja'].sample,
    specialties: ['Terapia Cognitivo-Conductual', 'Psicoanálisis', 'Terapia Familiar', 'Psicología Infantil', 'Neuropsicología'].sample(rand(1..3))
  )
end


# Create Services
psychologists.each do |psychologist|
  Service.create!(
    psychologist: psychologist,
    name: psychologist.full_name,
    country: psychologist.nationality,
    price_per_session: psychologist.price_per_hour,
    specialties: psychologist.specialties.join(', '),
    published: true
  )
end

# Crear disponibilidades de manera eficiente con insert_all
puts "Creando disponibilidades..."
availabilities_data = []

psychologists.each do |psychologist|
  # Crear más disponibilidades para un conjunto de datos más completo
  5.times do |j|
    # Disponibilidades para varios días en el futuro
    7.times do |day_offset|
      # Crear diferentes horarios por día
      4.times do |hour_offset|
        hour_start = 8 + hour_offset * 2 # Horarios de 8:00, 10:00, 12:00, 14:00
        business_date = Date.today + day_offset.days + j.days
        
        availabilities_data << {
          psychologist_id: psychologist.id,
          business_date: business_date,
          starting_hour: Time.zone.parse("#{hour_start}:00"),
          ending_hour: Time.zone.parse("#{hour_start + 1}:00"),
          reserved: false,
          created_at: Time.current,
          updated_at: Time.current
        }
      end
    end
  end
end

# Insertar todas las disponibilidades en un solo batch para mayor eficiencia
Availability.insert_all(availabilities_data) if availabilities_data.any?

# Las reseñas se crean al final del archivo para usar insert_all

# Crear reservas con estado de pago
puts "Creando reservas..."

# Crear menos combinaciones pero más realistas
users.shuffle.take(5).each_with_index do |user, user_index|
  psychologists.shuffle.take(3).each_with_index do |psychologist, psy_index|
    # Evitar que un psicólogo se reserve a sí mismo
    next if psychologist.user_id == user.id
    
    # Crear reservas en diferentes estados para pruebas
    date = Date.today + (user_index + 1).days
    time = Time.zone.parse("#{10 + psy_index}:00")
    
    # Buscar una disponibilidad existente y marcarla como reservada
    availability = Availability.where(
      psychologist_id: psychologist.id,
      business_date: date,
      starting_hour: time,
      reserved: false
    ).first
    
    # Si encontramos una disponibilidad, crear la reserva
    if availability
      booking = Booking.new(
        date: date,
        time: time,
        end_time: time + 1.hour,
        psychologist: psychologist,
        user: user,
        reason: ["Ansiedad", "Depresión", "Estrés", "Problemas de pareja", "Consulta general"].sample,
        sessions_requested: rand(1..5),
        sessions_completed: 0
      )
      
      # Guardar la reserva sin callbacks para evitar la creación de videollamada durante el seed
      booking.save(validate: false)
      
      # Marcar la disponibilidad como reservada
      availability.update(reserved: true)
      
      # Crear estado de pago (alternando entre pendiente y pagado)
      payment_status = (user_index + psy_index).even? ? 'paid' : 'pending'
      booking.create_payment_status!(status: payment_status)
      
      # Simular un ID de videollamada para algunas reservas
      if [true, false].sample
        booking.update(
          videocall_id: SecureRandom.hex(10),
          link_to_meet: "https://solvify.daily.co/#{SecureRandom.hex(10)}"
        )
      end
    end
  end
end

# Crear reseñas con calificaciones más realistas
puts "Creando reseñas..."
reviews_data = []

psychologists.each do |psychologist|
  # Número aleatorio de reseñas por psicólogo
  rand(3..10).times do
    # Usar una distribución más realista de calificaciones (favoreciendo las altas)
    rating = [4, 5, 5, 5, 4, 4, 3, 5, 4, 5].sample
    
    reviews_data << {
      psychologist_id: psychologist.id,
      comments: [
        "Excelente profesional, me ayudó mucho con mis problemas.",
        "Muy buena atención, recomendado.",
        "Un profesional muy competente y empático.",
        "La terapia me está ayudando bastante, gran profesional.",
        "Recomiendo ampliamente sus servicios."
      ].sample,
      ratings: rating,
      created_at: Time.current - rand(1..60).days,
      updated_at: Time.current
    }
  end
end

# Insertar todas las reseñas en un solo batch
Review.insert_all(reviews_data) if reviews_data.any?

end # Fin de la transacción

# Resultados del proceso de seeding
puts "==============================================="
puts "Proceso de seed completado exitosamente:"
puts "- #{User.count} usuarios creados"
puts "- #{Psychologist.count} psicólogos creados"
puts "- #{Service.count} servicios creados"
puts "- #{Availability.count} disponibilidades creadas"
puts "- #{Booking.count} reservas creadas"
puts "- #{PaymentStatus.count} estados de pago creados"
puts "- #{Review.count} reseñas creadas"
puts "==============================================="
