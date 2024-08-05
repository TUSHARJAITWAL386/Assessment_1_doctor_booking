puts "************************************************************\u{1F44B} Welcome to Doctor Booking Application \u{1F44B}************************************************************"
module SlotModule
  class Slot
    attr_accessor :id, :time, :patient

    def initialize(id,time)
      @id = id
      @time = time
      @patient = nil
    end

    def booked?
      !@patient.nil?
    end

    def book_patient(patient)
      @patient = patient
    end

    def cancel_booking
      @patient = nil
    end
  end
end

