require_relative('models/customer')
require_relative('models/film')
require_relative('models/screening')
require_relative('models/ticket')
require('pry-byebug')

Ticket.delete_all()
Screening.delete_all()
Film.delete_all()
Customer.delete_all()

customer1 = Customer.new({"name" => "Asma", "funds" => 50, "type" => "adult"})
customer1.save()

customer2 = Customer.new({"name" => "Sarah", "funds" => 10, "type" => "student"})
customer2.save()

customer3 = Customer.new({"name" => "Ali", "funds" => 10, "type" => "child"})
customer3.save()

customer4 = Customer.new({"name" => "Scott", "funds" => 15, "type" => "adult"})
customer4.save()

customer5 = Customer.new({"name" => "Karen", "funds" => 20, "type" => "adult"})
customer5.save()

customer6 = Customer.new({"name" => "Chris", "funds" => 2, "type" => "adult"})
customer6.save()


film1 = Film.new({"title" => "Avengers: Infinity War", "price" => 10 })
film1.save()

film2 = Film.new({"title" => "Black Panther", "price" => 10 })
film2.save()

film3 = Film.new({"title" => "Jurassic World: Fallen Kingdom", "price" => 10 })
film3.save()

# film4 = Film.new({"title" => "Incredibles", "price" => 10 })
# film4.save()
# film5 = Film.new({"title" => "Mission Impossible - Fallout", "price" => 10 })
# film5.save()

screening1 = Screening.new({"name" => "Screen 1", "capacity" => "10", "film_id" => film1.id, "start_time" => '2018-09-21 15:00:00'})
screening1.save()

screening2 = Screening.new({"name" => "Screen 1", "capacity" => "10", "film_id" => film1.id, "start_time" => '2018-09-21 18:30:00'})
screening2.save()

screening3 = Screening.new({"name" => "Screen 2", "capacity" => "5", "film_id" => film2.id, "start_time" => '2018-09-21 15:00:00'})
screening3.save()

screening4 = Screening.new({"name" => "Screen 2", "capacity" => "5", "film_id" => film2.id, "start_time" => '2018-09-21 19:00:00'})
screening4.save()

screening5 = Screening.new({"name" => "Screen 3", "capacity" => "2", "film_id" => film3.id, "start_time" => '2018-09-21 19:00:00'})
screening5.save()

screening6 = Screening.new({"name" => "Screen 3", "capacity" => "2", "film_id" => film3.id, "start_time" => '2018-09-21 22:30:00'})
screening6.save()


ticket1 = Ticket.new({"customer_id" => customer1.id, "screening_id" => screening1.id, "cost" => 10})
ticket1.save()

ticket2 = Ticket.new({"customer_id" => customer2.id, "screening_id" => screening1.id, "cost" => 8}) #Student ticket
ticket2.save()

ticket3 = Ticket.new({"customer_id" => customer3.id, "screening_id" => screening1.id, "cost" => 5}) #Child ticket
ticket3.save()

ticket4 = Ticket.new({"customer_id" => customer1.id, "screening_id" => screening6.id, "cost" => 10})
ticket4.save()

ticket5 = Ticket.new({"customer_id" => customer4.id, "screening_id" => screening6.id, "cost" => 10})
ticket5.save()

ticket6 = Ticket.new({"customer_id" => customer5.id, "screening_id" => screening6.id, "cost" => 10})
ticket6.save() #should not save as no more tickets available

ticket7 = Ticket.new({"customer_id" => customer6.id, "screening_id" => screening2.id, "cost" => 10})
ticket7.save() #should not save as the customer does not have enough funds

customers = Customer.all()
films = Film.all()
screenings = Screening.all()
tickets = Ticket.all()

# Customer.find_by_id(1)

# Test Update()
customer2.name = "Another customer"
customer2.update()

#Show which films a customer has booked to see
customer1.find_films()

#see which customers are coming to see one film
film1.find_customers()


binding.pry
nil
