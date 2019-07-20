module APIHelpers
  def upsert_params(model)
    model.new.attributes.map do |key, value|
      value == [] ? { key.to_sym => value } : key.to_sym
    end
  end
end