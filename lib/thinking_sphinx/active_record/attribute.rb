class ThinkingSphinx::ActiveRecord::Attribute <
  ThinkingSphinx::ActiveRecord::Property
  attr_reader :column

  def to_select_sql(associations, source)
    "#{casted_column_with_table(associations, source)} AS #{name}"
  end

  def type_for(model)
    @options[:type] || type_from_database_for(model)

    # @type ||= begin
    #   base_type = case
    #   when is_many?, is_many_ints?
    #     :multi
    #   when @associations.values.flatten.length > 1
    #     :string
    #   else
    #     translated_type_from_database
    #   end
    #
    #   if base_type == :string && @crc
    #     base_type = :integer
    #   else
    #     @crc = false unless base_type == :multi && is_many_strings? && @crc
    #   end
    #
    #   base_type
    # end
  end

  private

  def casted_column_with_table(associations, source)
    clause = column_with_table(associations)
    if type_for(source.model) == :timestamp
      source.adapter.cast_to_timestamp(clause)
    else
      clause
    end
  end

  def type_from_database_for(model)
    db_type = model.columns.detect { |db_column|
      db_column.name == column.__name.to_s
    }.type

    case db_type
    when :datetime
      :timestamp
    else
      db_type
    end
  end
end