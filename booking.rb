require_relative 'slot'
require_relative 'patient'
require 'debug'
module BookingModule
  class Booking
    attr_accessor :slots

    def initialize
      @slots = []
      create_slots
    end

    def create_slots
      start_time = Time.now
      delay_in_hours = 2
      
      5.times do |i|
        s = start_time + i * delay_in_hours * 3600
        @slots << Slot.new(i + 10, s.strftime("%D %I:%M%p"))
      end
    end


    def find_slot_by_id(id)
      @slots.find{|slot| slot.id==id}
    end


    def available_slots
      @slots.reject(&:booked?)
    end
    

    def view_slots
      puts "|   *SLOTS*   |        *DATE-TIME*   |   *STATUS*   "  
      puts '-------------------------------------------------------'
      @slots.each do |slot|
        if slot.booked?
          puts "|\u{1F4CC}   Slot-#{slot.id} |\u{23F0}   #{slot.time} |  Booked by #{slot.patient.name}"
        else
          puts "|\u{1F4CC}   Slot-#{slot.id} |\u{23F0}   #{slot.time} |  Available \u{2714} "
        end
      end
    end
      
    def add_patient_slot(slot_id,patient_details)
      slot = find_slot_by_id(slot_id)
      raise SlotAlreadyBookedError,"############ Slot Already Booked \u{1F60A} ############ " if slot.booked?

      patient = Patient.new(patient_details[:name],patient_details[:age],patient_details[:diseases],patient_details[:email])
      slot.book_patient(patient)
    end

    def view_patient_details(slot_id)
      slot = find_slot_by_id(slot_id)
      if slot.nil?
        puts "############ Please enter valid Slot Id \u{1F914} ############"
        return 
      end
      if slot.booked? 
        patient = slot.patient
        puts "==============================================="
        puts "\u{23E9}\u{23E9}\u{23E9}  Name :-- #{patient.name}"
        puts "\u{23E9}\u{23E9}\u{23E9}  Age :-- #{patient.age}"
        puts "\u{23E9}\u{23E9}\u{23E9}  Diseases :-- #{patient.diseases}"
        puts "\u{23E9}\u{23E9}\u{23E9}  Email :-- #{patient.email}"
        puts "\u{23E9}\u{23E9}\u{23E9}  Slot :-- #{slot.time}"
        puts "==============================================="
      else
        puts "############ No patient for this time slot \u{1F6AB} ############ "
      end
    end

    def delete_slot(slot_id)
      slot = find_slot_by_id(slot_id)
      @slots.delete(slot)
    end

    def remove_patient_from_slot(slot_id)
      slot = find_slot_by_id(slot_id)
      slot.cancel_booking
    end

    def update_patient_details(slot_id,new_details)
      slot = find_slot_by_id(slot_id)
      if slot && slot.booked?
        patient = slot.patient
        patient.name = new_details[:name] if new_details[:name]
        patient.age = new_details[:age] if new_details[:age]
        patient.diseases = new_details[:diseases] if new_details[:diseases]
        patient.email = new_details[:email] if new_details[:email]
        puts "############ patient details updated for slot #{slot_id} \u{2705} ############"
      else
        puts "############ Slot #{slot_id} does not exist or is not booked \u{1F644} ############"
      end
    end

    def booked_slots
      booked_slots = @slots.select { |slot| slot.patient != nil }

      if booked_slots.empty?
        puts "\u{27A1}\u{27A1}\u{27A1}\u{27A1}\u{27A1} Slots are not Booked yet \u{1F633} "
      else
        booked_slots.each do |bs|
          patient = bs.patient
          puts "\u{27A1}\u{27A1}\u{27A1}\u{27A1} | Slot-#{bs.id} | | Name :-- #{patient.name}     | |     Age :-- #{patient.age}      | |     Diseases :-- #{patient.diseases}      | |     Email :-- #{patient.email}        | |     Slot :-- #{bs.time} |"
        end
      end

    end
  end
  class SlotAlreadyBookedError < StandardError; end
end
