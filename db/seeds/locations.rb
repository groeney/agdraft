require_relative "./data/states"

@states.each do |state|
  state[:regions].each do |region|
    Location.create(state: state[:name], region: region)
  end
end