class Reminder < ApplicationRecord
  belongs_to :user
  default_scope -> { order(date: :asc, priority: :desc) }
  validates :user_id, presence: true
  validates :reference, presence: true
  validates :notes, presence: true
  validates :date, presence: true
  validates :service_type, presence: true
  validates :priority, presence: true
  validates_inclusion_of :complete, :in => [true, false]
end
