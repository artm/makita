module TabularSeed
  def self.into model, columns, *rows
    rows.map do |row|
      attributes = Hash[columns.zip(row)]
      model.create(attributes)
    end
  end
end
