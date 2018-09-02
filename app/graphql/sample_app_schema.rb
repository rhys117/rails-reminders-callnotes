class SampleAppSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
  use GraphQL::Guard.new(
      # By default it raises an error
      # not_authorized: ->(type, field) { raise GraphQL::Guard::NotAuthorizedError.new("#{type}.#{field}") }

      # Returns an error in the response
      not_authorized: ->(type, field) { GraphQL::ExecutionError.new("Not authorized to access #{type}.#{field}") }
  )
end
