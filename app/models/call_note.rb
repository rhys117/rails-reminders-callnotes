class CallNote < ApplicationRecord
  attr_accessor :call_type, :phone_number, :call_answer, :id_check, :additional_notes, :call_conclusion,
                :call_conclusion, :conclusion_condition, :conclusion_agreed_contact, :conclusion_contact_date,
                :conclusion_best_contact

  private
    def normalize_blank_values
      attributes.each do |column, value|
        self[column].present? || self[column] = nil
      end
    end
end
