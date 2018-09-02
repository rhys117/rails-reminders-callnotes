Types::UserType = GraphQL::ObjectType.define do
  name 'User'
  guard ->(obj, args, ctx) do
    return unless ctx[:current_user]
    ctx[:current_user].id == ctx[:session][:user_id]
  end

  # it has the following fields
  field :id, !types.ID
  field :name, !types.String
  field :email, !types.String
end