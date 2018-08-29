class Reminder < ApplicationRecord
  attr_accessor :select_date
  before_save :override_date
  before_save :normalize_blank_values
  before_save :complete_false_if_nil

  belongs_to :user
  scope :ordered_date_completed_priority, -> { order(date: :ASC, complete: :ASC, priority: :DESC, id: :ASC) }
  scope :ordered_priority, -> { order(priority: :DESC, id: :ASC) }
  validates :user_id, presence: true
  validates :reference, presence: true, numericality: { only_integer: true }
  validates :vocus_ticket, numericality: { allow_blank: true, only_integer: true }
  validates :notes, presence: true, unless: -> (reminder){reminder.check_for.present?}
  validates :date, presence: true, unless: -> (reminder){reminder.select_date.present?}
  validates :service_type, presence: true
  validates :priority, presence: true
  validates_inclusion_of :complete, :in => [true, false]

  before_validation :clean_data
  before_validation :complete_false_if_nil


def self.search(search)
  if Rails.env.development?
    where("nbn_search LIKE ? OR fault_type LIKE ? OR notes LIKE ? OR service_type LIKE ? OR reference LIKE ? OR check_for LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  else
    where("nbn_search ILIKE ? OR fault_type ILIKE ? OR notes ILIKE ? OR service_type ILIKE ? OR reference ILIKE ? OR check_for ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  end
end

  private

    def complete_false_if_nil
      self.complete = false if self.complete.nil?
    end

    def override_date
      unless self.select_date.nil? || self.select_date.length <= 0
        self.date = Date.current.next_day(self.select_date[0].to_i)
      end
    end

    def clean_data
      # trim whitespace from beginning and end of string attributes
      attribute_names.each do |name|
        if send(name).respond_to?(:strip)
          send("#{name}=", send(name).strip)
        end
      end
    end

    def normalize_blank_values
      attributes.each do |column, _|
        self[column].present? || self[column] = nil
      end
    end
end
