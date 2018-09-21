require_relative("../db/sql_runner")

class Customer

  attr_reader :id
  attr_accessor :name, :funds, :type

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @funds = options["funds"].to_f
    @type = options["type"]
  end

  def save()
    sql = "INSERT INTO customers
      (
        name,
        funds,
        type
      )
      VALUES
      (
        $1,
        $2,
        $3
      )
      RETURNING Id"
    values = [@name, @funds, @type]
    customer = SqlRunner.run(sql, values).first()
    @id = customer['id'].to_i
  end

  def find()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@id]
    customer = SqlRunner.run(sql, values)
    return Customer.new(customer[0])
  end

  def update()
    sql = "UPDATE customers SET (name, funds, type) = ($1, $2, $3) WHERE id = $4"
    values = [@name, @funds, @type, @id]
    SqlRunner.run(sql, values)
  end

  def find_films()
    sql = "SELECT films.*
          FROM films
          INNER JOIN screenings
          ON screenings.film_id = films.id
          INNER JOIN tickets
          ON tickets.screening_id = screenings.id
          WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map{|film| Film.new(film)}
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    customer = SqlRunner.run(sql, values)
    return Customer.new(customer[0])
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    result = customers.map{|customer| Customer.new(customer)}
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

end
