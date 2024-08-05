require_relative  'booking'

include SlotModule
include PatientModule
include BookingModule

def main
  system = Booking.new

  loop do
    puts "\u{1F449} 1. View All Slots"
    puts "\u{1F449} 2. Add Patient To Slot"
    puts "\u{1F449} 3. View Patient Details"
    puts "\u{1F449} 4. Delete Patient Slot"
    puts "\u{1F449} 5. Update Patient Details"
    puts "\u{1F449} 6. View All Booked Slots"
    puts "\u{1F449} 7. Remove Patient From Slot"
    puts "\u{1F449} 8. Exit"
    choice = gets.chomp().to_i

    case choice
    when 1
      system.view_slots
    when 2
      puts "Enter slot ID to book \u{1F4DD}"
      slot_id = gets.chomp().to_i
      if system.view_slots.map(&:id).include?(slot_id)
        puts "############ Enter The Patient Details ############"
        puts "Enter Patient's Name \u{1F4DD} "
        name = gets.chomp
        puts "Enter Patient's Age \u{1F4DD} "
        age = gets.chomp
        puts "Enter Patient's Disease \u{1F4DD} "
        diseases = gets.chomp
        puts "Enter Patient's Email \u{1F4DD} "
        email= gets.chomp

        patient_details = {name: name, age: age,diseases: diseases,email: email}

        begin
          system.add_patient_slot(slot_id,patient_details)
          puts "############ Patient added successfully \u{1F389} ############ "
        rescue SlotAlreadyBookedError => e
          puts e.message
          puts "Available slots:"
          system.available_slots.each { |slot| puts "\u{27A1}\u{27A1} Slot #{slot.id} (#{slot.time})" }
        rescue StandardError => e
          puts e.message
        end
      else
        puts "############ Please choose valid slot ID \u{1F914} ############ "
      end
    when 3
      puts "Enter slot ID to view patient details \u{1F4DD} "
      slot_id = gets.chomp().to_i
      system.view_patient_details(slot_id)
    when 4
      puts "Enter Slot ID to remove patient \u{1F4DD}"
      slot_id = gets.chomp().to_i
      if system.delete_slot(slot_id)
        puts "############ Patient deleted successfully \u{1F389} ############ "
      else
        puts "############ Please choose valid slot ID \u{1F914} ############ "
      end
    when 5
      puts "Enter Slot ID to Update Patient Details \u{1F4DD} "
      slot_id = gets.chomp.to_i
      puts "############ Enter Patient Details ########### "
      puts "Enter the patient name or press enter for unchanged \u{1F4DD}\u{23ED} "
      name = gets.chomp()
      puts "Enter the patient age or press enter for unchanged \u{1F4DD}\u{23ED} "
      age = gets.chomp()
      puts "Enter the patient diseases or press enter for unchanged \u{1F4DD}\u{23ED} "
      diseases = gets.chomp()
      puts "Enter the patient eamil or press enter for unchanged \u{1F4DD}\u{23ED} "
      email = gets.chomp()

      new_details = {name: name.empty? ? nil : name , age: age.empty? ? nil : age, diseases: diseases.empty? ? nil : diseases, email: email.empty? ? nil : email}
      system.update_patient_details(slot_id,new_details)
    when 6
      puts "############ View all Booked Slots Details ############"
      puts "-----------------------------------------------------------------------------------------------------------------------------------------------------------"
      system.booked_slots
    when 7
      puts "Enter Slot ID to remove patient \u{1F4DD} "
      slot_id = gets.chomp.to_i
      system.remove_patient_from_slot(slot_id)
      puts "############ Patient booking successfully canceled \u{1F389}  ############ "
    when 8
      puts "############\u{1F44B} \u{1F44B}  Bye-Bye  \u{1F44B} \u{1F44B} ############"
      break
    else
      puts "############ Invalid Choice, pelase try again \u{1F914} ############ "
    end
  end
end

main
