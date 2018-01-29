class CallNote < ApplicationRecord
  attr_accessor :call_type, :phone_number, :call_answer, :id_check, :additional_notes, :call_conclusion

  private
    def normalize_blank_values
      attributes.each do |column, value|
        self[column].present? || self[column] = nil
      end
    end
end
