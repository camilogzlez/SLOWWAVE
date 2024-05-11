# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "open-uri"

User.destroy_all
Photo.destroy_all
Category.destroy_all
Project.destroy_all

camilo = User.create!(email: "camilogzlez@gmail.com", password: "camilogzlez")
camilo.save!

puts "Creando user"

photo1 = Photo.create!(
  title: "mate",
  date: Date.new(2021, 4, 14, 18),
  location: "Buenos Aires",
  description: "tarde soleada",
  user: camilo
)

puts "Creando photos"

photo1.photo.attach(io: open("https://res.cloudinary.com/camilogzlez/image/upload/v1617216036/SLOWWAVE/Camilo_Beso_editada2_Cancion1_phzrjp.jpg"), filename: "photo1.png", content_type: "image/jpeg")
photo1.save!


photo2 = Photo.create!(
  title: "Faro",
  date: Date.new(2021, 4, 14, 18),
  location: "Buenos Aires",
  description: "Noche de Faro en recoleta",
  user: camilo
)
photo2.photo.attach(io: open("https://res.cloudinary.com/camilogzlez/image/upload/v1617215960/SLOWWAVE/Camilo_Tp6_Clave_baja_5_yvnud7.jpg"), filename: "photo2.png", content_type: "image/jpeg")
photo2.save!

photo3 = Photo.create!(
  title: "Chalten",
  date: Date.new(2021, 4, 14, 18),
  location: "Chalten patagonia",
  description: "Camino al tres hermanos",
  user: camilo
)
photo3.photo.attach(io: open("https://res.cloudinary.com/camilogzlez/image/upload/v1617215861/SLOWWAVE/ice_mjopiw.jpg"), filename: "photo3.png", content_type: "image/jpeg")
photo3.save!

photo4 = Photo.create!(
  title: "FacultadLove",
  date: Date.new(2021, 4, 14, 18),
  location: "Facultad de Derecho, Bs As.",
  description: "Pareja besandose",
  user: camilo
)
photo4.photo.attach(io: open("https://res.cloudinary.com/camilogzlez/image/upload/v1617216003/SLOWWAVE/Camilo_Zap_editada_Cancion_4_tpdvqf.jpg"), filename: "photo4.png", content_type: "image/jpeg")
photo4.save!

photo5 = Photo.create!(
  title: "Librarycompanion",
  date: Date.new(2021, 4, 14, 18),
  location: "Biblioteca Nacional, Bs As.",
  description: "Pareja",
  user: camilo
)

photo5.photo.attach(io: open("https://res.cloudinary.com/camilogzlez/image/upload/v1617215915/SLOWWAVE/wind2_t2ge6h.jpg"), filename: "photo5.png", content_type: "image/jpeg")
photo5.save!


photo6 = Photo.create!(
  title: "Librarycompanion",
  date: Date.new(2021, 4, 14, 18),
  location: "Biblioteca Nacional, Bs As.",
  description: "Pareja",
  user: camilo
)

photo6.photo.attach(io: open("https://res.cloudinary.com/camilogzlez/image/upload/v1646599008/SLOWWAVE/DSCF3692_bht62s.jpg"), filename: "photo6.png", content_type: "image/jpeg")
photo6.save!


photo7 = Photo.create!(
  title: "Librarycompanion",
  date: Date.new(2021, 4, 14, 18),
  location: "Biblioteca Nacional, Bs As.",
  description: "Pareja",
  user: camilo
)

photo7.photo.attach(io: open("https://res.cloudinary.com/camilogzlez/image/upload/v1646598964/SLOWWAVE/DSCF3635_g2kz1s.jpg"), filename: "photo7.png", content_type: "image/jpeg")
photo7.save!

photo8 = Photo.create!(
  title: "Librarycompanion",
  date: Date.new(2021, 4, 14, 18),
  location: "Biblioteca Nacional, Bs As.",
  description: "Pareja",
  user: camilo
)

photo8.photo.attach(io: open("https://res.cloudinary.com/camilogzlez/image/upload/v1646599070/SLOWWAVE/DSCF3969_yymk42.jpg"), filename: "photo8.png", content_type: "image/jpeg")
photo8.save!

photo9 = Photo.create!(
  title: "Librarycompanion",
  date: Date.new(2021, 4, 14, 18),
  location: "Biblioteca Nacional, Bs As.",
  description: "Pareja",
  user: camilo
)

photo9.photo.attach(io: open("https://res.cloudinary.com/camilogzlez/image/upload/v1646599099/SLOWWAVE/DSCF4039_v0zjfh.jpg"), filename: "photo9.png", content_type: "image/jpeg")
photo9.save!




puts "Creating four categories"

Street = Category.create!(name: 'Street')
Travel = Category.create!(name: 'Travel')
Nature = Category.create!(name: 'Nature')
Portrait = Category.create!(name: 'Portrait')

puts "Creating five relationships category-photo"

CategoryPhoto.create!(photo: photo1, category: Street)
CategoryPhoto.create!(photo: photo2, category: Street)
CategoryPhoto.create!(photo: photo3, category: Travel)
CategoryPhoto.create!(photo: photo4, category: Portrait)
CategoryPhoto.create!(photo: photo5, category: Nature)
CategoryPhoto.create!(photo: photo6, category: Portrait)
CategoryPhoto.create!(photo: photo7, category: Portrait)
CategoryPhoto.create!(photo: photo8, category: Street)
CategoryPhoto.create!(photo: photo9, category: Street)

puts "Creating four projects"

tango = Project.create!(title: 'Tango')
bares_notables = Project.create!(title: 'Bares Notables')

ProjectPhoto.create!(photo: photo3, project: tango)
ProjectPhoto.create!(photo: photo4, project: bares_notables)


puts "Seeds Creadas"
