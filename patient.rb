module PatientModule
  class Patient
  attr_accessor :name, :age, :diseases, :email

  def initialize(name,age,diseases,email)
    raise EmailNotValidError,"############ Email not valid \u{1F622} ############ " unless email.end_with?("@gmail.com")
    @name = name
    @age = age
    @diseases = diseases
    @email = email
  end
end

  class EmailNotValidError < StandardError; end 
end