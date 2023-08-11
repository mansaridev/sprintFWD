class MemberSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :first_name, :last_name, :city, :state, :country
end
