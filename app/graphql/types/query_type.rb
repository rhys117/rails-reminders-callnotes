Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  # queries are just represented as fields
  field :User, !types[Types::UserType] do
    guard ->(obj, args, ctx) do
      return unless ctx[:current_user]
      ctx[:current_user].id == ctx[:session][:user_id]
    end
    # resolve would be called in order to fetch data for that field
    resolve -> (obj, args, ctx) { User.all }
  end

  field :Reminder, !types[Types::ReminderType] do
    resolve -> (obj, args, ctx) { Reminder.all }
  end
end