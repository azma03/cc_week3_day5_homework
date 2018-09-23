require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_accessor :name, :seats_available, :film_id, :start_time

  def initialize(options)
      @id = options["id"].to_i if options["id"]
      @name = options["name"]
      @seats_available = options["seats_available"].to_i
      @film_id = options["film_id"].to_i
      @start_time = options["start_time"]
  end

  def save()
    sql = "INSERT INTO screenings
      (
        name,
        seats_available,
        film_id,
        start_time
      )
      VALUES
      (
        $1,
        $2,
        $3,
        $4
      )
      RETURNING Id"
    values = [@name, @seats_available, @film_id, @start_time]
    screening = SqlRunner.run(sql, values).first()
    @id = screening['id'].to_i
  end

  def find()
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@id]
    screening = SqlRunner.run(sql, values)
    return Screening.new(screening[0])
  end

  def update()
    sql = "UPDATE screenings SET (name, seats_available, film_id, start_time) = ($1, $2, $3, $4) WHERE id = $5"
    values = [@name, @seats_available, @film_id, @start_time, @id]
    SqlRunner.run(sql, values)
  end

  def find_by_id(id)
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [id]
    screening = SqlRunner.run(sql, values)
    return Screening.new(screening[0])
  end

  def get_film()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    film = SqlRunner.run(sql, values)
    return Film.new(film[0])
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    result = screenings.map{|screening| Screening.new(screening)}
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

end
