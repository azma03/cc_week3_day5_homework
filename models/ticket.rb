require_relative("../db/sql_runner")
require('pry-byebug')

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :screening_id, :cost

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @customer_id = options["customer_id"].to_i
    @screening_id = options["screening_id"].to_i
    @cost = options["cost"].to_f
  end

  def save()
    sql = "INSERT INTO tickets
      (
        customer_id,
        screening_id,
        cost
      )
      VALUES
      (
        $1,
        $2,
        $3
      )
      RETURNING Id"
    values = [@customer_id, @screening_id, @cost]
    ticket = SqlRunner.run(sql, values).first()
    @id = ticket['id'].to_i
  end

  def find()
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [@id]
    ticket = SqlRunner.run(sql, values)
    return Ticket.new(ticket[0])
  end

  def update()
    sql = "UPDATE tickets SET (customer_id, screening_id, cost) = ($1, $2, $3) WHERE id = $4"
    values = [@customer_id, @screening_id, @cost, @id]
    SqlRunner.run(sql, values)
  end

  def find_by_id(id)
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [id]
    ticket = SqlRunner.run(sql, values)
    return Ticket.new(ticket[0])
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    result = tickets.map{|ticket| Ticket.new(ticket)}
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def self.get_discount_price(customer, screening)
    film = screening.get_film()
    discount_rate = case customer.type
      when "adult" then 1
      when "student" then (1 - 0.2) # 20% discount for student ticket
      when "child" then (1 - 0.5) # 50% discount for child ticket
      else 1
    end
    discount_price = film.price * discount_rate
    return discount_price
  end

  def self.customer_has_enough_funds(customer, screening)
    discount_price = get_discount_price(customer, screening)
    if customer.funds >= discount_price
      return true
    else
      return false
    end
  end


  def self.sell_ticket(customer, screening)
    # if the customer has enough funds
    # and the remaining tickets for the screening is greater than zero
    if (customer_has_enough_funds(customer, screening) && screening.seats_available > 0)

      # get (any) discount price based on customer type
      cost = get_discount_price(customer, screening)

      # take out the price from customer's funds
      customer.funds -= cost
      # push the changes to the database
      customer.update()
      # create a new ticket object with the above details
      ticket = Ticket.new({
        "customer_id" => customer.id,
        "screening_id" => screening.id,
        "cost" => cost
        })
      ticket.save()

      # decrement the screening's seats available
      screening.seats_available -= 1
      #push the changes to the database
      screening.update()
    end
  end

  # def check_if_tickets_are_sold(film)
  #   tickets = all()
  #
  # end

end
