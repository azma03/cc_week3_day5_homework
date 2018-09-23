require_relative("../db/sql_runner")

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
      @id = options["id"].to_i if options["id"]
      @title = options["title"]
      @price = options["price"].to_f
  end

  def save()
    sql = "INSERT INTO films
      (
        title,
        price
      )
      VALUES
      (
        $1,
        $2
      )
      RETURNING Id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first()
    @id = film['id'].to_i
  end

  def find()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@id]
    film = SqlRunner.run(sql, values)
    return Film.new(film[0])
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def find_by_id(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    film = SqlRunner.run(sql, values)
    return Film.new(film[0])
  end

  def find_customers()
    sql = "SELECT customers.*
          FROM customers
          INNER JOIN tickets
          ON tickets.customer_id = customers.id
          INNER JOIN screenings
          ON screenings.id = tickets.screening_id
          WHERE screenings.film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map{|customer| Customer.new(customer)}
  end

  def customer_count()
    sql = "SELECT count(customer_id)
          FROM tickets
          INNER JOIN screenings
          ON screenings.id = tickets.screening_id
          INNER JOIN films
          ON films.id = screenings.film_id
          WHERE films.id = $1"
    values = [id]
    customer_count = SqlRunner.run(sql, values)[0]["count"].to_i
    return customer_count
  end

  def find_most_popular_time()
    # if (Ticket.check_if_tickets_are_sold(self))
      sql = "SELECT screenings.film_id, screenings.start_time, count(screenings.start_time)
            FROM screenings
            INNER JOIN tickets
            ON tickets.screening_id = screenings.id
            GROUP BY screenings.film_id, screenings.start_time
            HAVING screenings.film_id = $1
            ORDER BY  screenings.film_id, count(screenings.start_time) DESC
            LIMIT 1;"
      values = [id]
      most_popular_time = SqlRunner.run(sql, values)[0]["start_time"]
      return most_popular_time
    # end
  end

  def self.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    result = films.map{|film| Film.new(film)}
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
