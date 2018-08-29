Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :createReminder, function: Resolvers::CreateReminder.new
end