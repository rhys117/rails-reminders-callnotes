class Reminder < ApplicationRecord
  attr_accessor :select_date
  before_save :override_date
  before_save :normalize_blank_values
  before_save :complete_false_if_nil

  belongs_to :user
  scope :ordered_date_completed_priority, -> { order(date: :ASC, complete: :ASC, priority: :DESC) }
  scope :ordered_priority, -> { order(priority: :DESC) }
  validates :user_id, presence: true
  validates :reference, presence: true
  validates :notes, presence: true, unless: -> (reminder){reminder.check_for.present?}
  validates :date, presence: true, unless: -> (reminder){reminder.select_date.present?}
  validates :service_type, presence: true
  validates :priority, presence: true
  validates_inclusion_of :complete, :in => [true, false]


def self.search(search)
  where("nbn_search ILIKE ? OR notes ILIKE ? OR service_type ILIKE ? OR reference ILIKE ? OR check_for ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
end

  private

    def complete_false_if_nil
      self.complete = false if self.complete.nil?
    end

    def override_date
      if self.date.nil?
        self.date = Date.today.next_day(self.select_date[0].to_i)
      end
    end

    def normalize_blank_values
      attributes.each do |column, value|
      self[column].present? || self[column] = nil
    end
  end
end
