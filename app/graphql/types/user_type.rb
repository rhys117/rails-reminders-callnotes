Types::UserType = GraphQL::ObjectType.define do
  name 'User'

  # it has the following fields
  field :id, !types.ID
  field :name, !types.String
  field :email, !types.String
end