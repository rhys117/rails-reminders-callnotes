class CallNote < ApplicationRecord
  attr_accessor :call_type, :phone_number, :call_answer, :id_check, :enquiry_notes, :call_conclusion,
                :call_conclusion, :conclusion_condition, :conclusion_agreed_contact, :conclusion_contact_date,
                :conclusion_best_contact, :work_notes, :correspondence_notes, :enquiry_category, :not_onsite

  private

  def normalize_blank_values
    attributes.each do |column, _|
      self[column].present? || self[column] = nil
    end
  end
end
