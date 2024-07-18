require_relative '../app/services/daily_service'

Review.destroy_all
Availability.destroy_all
Booking.destroy_all
Service.destroy_all
Psychologist.destroy_all
User.destroy_all

daily_service = DailyService.new('afd0d96efeb72db1d03e5c1618aaa78a35e2ecac1cd249b411ce2196ceddae26')
daily_service.delete_all_rooms

def normalize_name(name)
  name.downcase.gsub(/[^a-z]/, '')
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
  last_name = Faker::Name.last_name

  normalized_first_name = normalize_name(first_name)
  normalized_last_name = normalize_name(last_name)
  email = "#{normalized_first_name}.#{normalized_last_name}@example.com"


  nationality = Faker::Nation.nationality
  users << User.create!(
    name: first_name,
    last_name: last_name,
    email: email,
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
  last_name = Faker::Name.last_name

  normalized_first_name = normalize_name(first_name)
  normalized_last_name = normalize_name(last_name)
  email = "#{normalized_first_name}.#{normalized_last_name}@example.com"

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
    last_name: last_name,
    email: email,
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
  users.each_with_index do |user, index|
    Booking.create!(
      date: Date.today + (index + 1).days,
      time: "10:00",
      end_time: "11:00",
      psychologist: psychologist,
      user: user,
      payment_status: PaymentStatus.find_or_create_by(status: 'pending'),
      link_to_meet: '',
      # link_to_meet: "https://solvify.daily.co/#{SecureRandom.hex(10)}",
      reason: "Consulta de prueba"
    )
  end
end

puts "Seeded #{User.count} users, #{Psychologist.count} psychologists, #{Service.count} services, #{Availability.count} availabilities, #{Review.count} reviews, and #{Booking.count} bookings."
