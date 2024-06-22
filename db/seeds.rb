# Limpia la base de datos
Booking.destroy_all
Availability.destroy_all
Review.destroy_all
Psychologist.destroy_all
User.destroy_all

# Crear un usuario normal
user = User.create!(
  email: "user@example.com",
  password: "password",
  password_confirmation: "password",
  name: "John",
  last_name: "Doe",
  date_of_birth: "1990-01-01",
  gender: "Male",
  address: "123 Main St",
  nationality: "American"
)

# Crear un usuario psicólogo
psychologist_user = User.create!(
  email: "psychologist@example.com",
  password: "password",
  password_confirmation: "password",
  name: "Jane",
  last_name: "Smith",
  date_of_birth: "1985-05-15",
  gender: "Female",
  address: "456 Elm St",
  nationality: "American"
)

# Crear un psicólogo asociado al usuario psicólogo
psychologist = Psychologist.create!(
  user: psychologist_user,
  specialty: "Clinical Psychology",
  degree: "PhD",
  document_of_identity: "123456789",
  availability: true,
  years_of_experience: 10,
  description: "Experienced clinical psychologist",
  average_rating: 4.5,
  price_per_hour: 100.0
)

# Crear una disponibilidad para el psicólogo
availability = Availability.create!(
  psychologist: psychologist,
  business_date: Date.today,
  starting_hour: "09:00",
  ending_hour: "17:00"
)

# Crear una reserva lógica para el usuario con el psicólogo
booking = Booking.create!(
  user: user,
  psychologist: psychologist,
  date: Date.today,
  time: "10:00"
)

# Crear una reseña para el psicólogo
review = Review.create!(
  psychologist: psychologist,
  comments: "Great psychologist!",
  ratings: 5
)

puts "Seeding completed successfully."
