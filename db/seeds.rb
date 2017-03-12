# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#


School.create(name: "Benemérito Instituto Normal del Estado",
              url: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Logotipo_2014_BINE.png/220px-Logotipo_2014_BINE.png")
School.create(name: "CENCH",
              url: "http://bandasdemusicapuebla.mx/banda3/wp-content/uploads/2015/06/LOGO-BANDA-CENHCH.png")
School.create(name: "Centro Escolar José Maria Morelos y Pavón",
              url: "http://www.centroescolarmorelos.edu.mx/imagenes/cabeza_01.png")
School.create(name: "Instituto Mexicano Madero",
              url: "http://www.imm.edu.mx/toledo/images/easyblog_images/63/logoimm2.png")

if Admin.count == 0
  Admin.new({:email => "m@gmail.com", :password => "123456", :password_confirmation => "123456", :confirmed_at => Time.now }).save(false)
end