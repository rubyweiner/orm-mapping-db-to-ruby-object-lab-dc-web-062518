require 'pry'

class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]

    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ? LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
    #binding.pry
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(name) FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql)
    #binding.pry
  end


  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    student_arr = []

    DB[:conn].execute(sql).each do |student|
      student_arr << self.new_from_db(student)
    end
   student_arr
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    student_arr = []

    DB[:conn].execute(sql, x).each do |student|
      student_arr << self.new_from_db(student)
    end
    student_arr
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
    SQL

    first_student = DB[:conn].execute(sql).first
    return self.new_from_db(first_student)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    student_arr = []

    DB[:conn].execute(sql, x).each do |student|
      student_arr << self.new_from_db(student)
    end
   student_arr

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
