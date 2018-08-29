Types::ReminderType = GraphQL::ObjectType.define do
  name 'Reminder'

  # it has the following fields
  field :id, !types.ID
  field :name, !types.String
  field :notes, types.String
  field :date, !types.String
  field :user_id, !types.String
  field :check_for, types.String
end