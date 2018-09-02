Types::ReminderType = GraphQL::ObjectType.define do
  name 'Reminder'
  guard ->(obj, args, ctx) do
    return unless ctx[:current_user]
    ctx[:current_user].id == ctx[:session][:user_id]
  end

  # it has the following fields
  field :id, !types.ID
  field :name, !types.String
  field :notes, types.String
  field :date, !types.String
  field :check_for, types.String

  field :User, -> { Types::UserType }, property: :user
end