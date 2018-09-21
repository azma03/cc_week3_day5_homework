require_relative("../db/sql_runner")

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

end
