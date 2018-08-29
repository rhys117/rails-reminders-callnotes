class Resolvers::CreateReminder < GraphQL::Function
  # arguments passed as "args"
  argument :date, !types.String
  argument :user_id, !types.String
  argument :reference, !types.String
  argument :priority, !types.String
  argument :service_type, !types.String

  argument :complete, types.Boolean
  argument :vocus_ticket, types.String
  argument :nbn_search, types.String
  argument :notes, types.String
  argument :check_for, types.String
  argument :fault_type, types.String
  argument :vocus, types.Boolean

  # return type from the mutation
  type Types::ReminderType

  # the mutation method
  # _obj - is parent object, which in this case is nil
  # args - are the arguments passed
  # _ctx - is the GraphQL context (which would be discussed later)
  def call(_obj, args, _ctx)
    Reminder.create!(
        date: args[:date],
        user_id: args[:user_id],
        reference: args[:reference],
        priority: args[:priority].to_i,
        service_type: args[:service_type],
        complete: args[:complete],
        vocus_ticket: args[:vocus_ticket],
        nbn_search: args[:nbn_search],
        notes: args[:notes],
        check_for: args[:check_for],
        fault_type: args[:fault_type],
        vocus: args[:vocus]
    )
  end
end