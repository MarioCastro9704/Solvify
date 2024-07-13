# db/seeds.rb

# Clear existing data
Booking.destroy_all
Review.destroy_all
Availability.destroy_all
Service.destroy_all
Psychologist.destroy_all
User.destroy_all

# Create Users
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
users << User.create!(
  name: "Carlos",
  last_name: "Pérez",
  email: "carlos.perez@example.com",
  password: 'password',
  date_of_birth: "1990-09-17",
  gender: "Masculino",
  address: "Avenida Siempre Viva 742, Ciudad",
  nationality: "México"
)
users << User.create!(
  name: "Laura",
  last_name: "López",
  email: "laura.lopez@example.com",
  password: 'password',
  date_of_birth: "1992-11-11",
  gender: "Femenino",
  address: "Calle Principal 456, Ciudad",
  nationality: "Chile"
)
users << User.create!(
  name: "Juan",
  last_name: "Martínez",
  email: "juan.martinez@example.com",
  password: 'password',
  date_of_birth: "1988-02-14",
  gender: "Masculino",
  address: "Pasaje Secundario 789, Ciudad",
  nationality: "Colombia"
)
users << User.create!(
  name: "María",
  last_name: "Rodríguez",
  email: "maria.rodriguez@example.com",
  password: 'password',
  date_of_birth: "1995-07-29",
  gender: "Femenino",
  address: "Boulevard Central 321, Ciudad",
  nationality: "Perú"
)

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
psychologists << User.create!(
  name: "Dra. Elena",
  last_name: "Gómez",
  email: "elena.gomez@example.com",
  password: 'password',
  date_of_birth: "1980-08-15",
  gender: "Femenino",
  address: "Avenida Psicología 456, Ciudad",
  nationality: "Argentina"
).create_psychologist!(
  degree: "Licenciatura en Psicología",
  document_of_identity: "DNI87654321",
  price_per_hour: 80,
  approach: "Psicoanálisis",
  languages: "Español, Francés",
  nationality: "Argentina",
  currency: "USD",
  specialty: "Psicoanálisis",
  specialties: ["Psicoanálisis", "Terapia Familiar"]
)
psychologists << User.create!(
  name: "Dr. Roberto",
  last_name: "Fernández",
  email: "roberto.fernandez@example.com",
  password: 'password',
  date_of_birth: "1983-12-05",
  gender: "Masculino",
  address: "Calle Terapia 789, Ciudad",
  nationality: "Chile"
).create_psychologist!(
  degree: "Licenciatura en Psicología",
  document_of_identity: "DNI11223344",
  price_per_hour: 75,
  approach: "Terapia Familiar",
  languages: "Español, Italiano",
  nationality: "Chile",
  currency: "CLP",
  specialty: "Terapia Familiar",
  specialties: ["Terapia Familiar", "Psicología Infantil"]
)
psychologists << User.create!(
  name: "Dra. Laura",
  last_name: "Hernández",
  email: "laura.hernandez@example.com",
  password: 'password',
  date_of_birth: "1987-06-25",
  gender: "Femenino",
  address: "Boulevard Terapia 321, Ciudad",
  nationality: "México"
).create_psychologist!(
  degree: "Licenciatura en Psicología",
  document_of_identity: "DNI44556677",
  price_per_hour: 65,
  approach: "Terapia Cognitivo-Conductual",
  languages: "Español, Alemán",
  nationality: "México",
  currency: "MXN",
  specialty: "Terapia Cognitivo-Conductual",
  specialties: ["Terapia Cognitivo-Conductual", "Neuropsicología"]
)
psychologists << User.create!(
  name: "Dr. Luis",
  last_name: "García",
  email: "luis.garcia@example.com",
  password: 'password',
  date_of_birth: "1982-01-30",
  gender: "Masculino",
  address: "Avenida Psicología 987, Ciudad",
  nationality: "Perú"
).create_psychologist!(
  degree: "Licenciatura en Psicología",
  document_of_identity: "DNI99887766",
  price_per_hour: 90,
  approach: "Psicología Organizacional",
  languages: "Español, Portugués",
  nationality: "Perú",
  currency: "PEN",
  specialty: "Psicología Organizacional",
  specialties: ["Psicología Organizacional", "Terapia de Pareja"]
)

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

# Create Availabilities
psychologists.each do |psychologist|
  3.times do |j|
    Availability.create!(
      psychologist: psychologist,
      business_date: Date.today + j.days,
      starting_hour: "#{9 + j}:00",
      ending_hour: "#{10 + j}:00"
    )
  end
end

# Create Reviews
psychologists.each do |psychologist|
  3.times do |j|
    Review.create!(
      psychologist: psychologist,
      comments: "Comentario de revisión #{j + 1} para #{psychologist.full_name}",
      ratings: rand(1..5)
    )
  end
end

# Create Bookings with alternating payment statuses
psychologists.each do |psychologist|
  2.times do |j|
    Booking.create!(
      date: Date.today + (j + 1).weeks,
      time: "10:00",
      end_time: "11:00",
      psychologist: psychologist,
      user: users.sample,
      payment_status: j.even? ? 'paid' : 'pending',
      link_to_meet: j.even? ? "https://solvify.daily.co/#{SecureRandom.hex(10)}" : nil,
      reason: "Consulta de prueba"
    )
  end
end

puts "Seeded #{User.count} users, #{Psychologist.count} psychologists, #{Service.count} services, #{Availability.count} availabilities, #{Review.count} reviews, and #{Booking.count} bookings."
