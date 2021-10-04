require 'active_support/core_ext/string/inflections'

module Everything
  class Analysis
    class Table
      attr_accessor :columns, :rows

      def initialize
        self.columns = []
        self.rows = []
      end

      def add_columns(*column_names)
        column_names.each do |column_name|
          self.columns << {
            name: column_name,
            max_length: column_name.to_s.pluralize.length,
          }
        end
      end

      def add_row(row_data)
        self.rows << row_data.map do |column_name, row_value|
          column = columns.find{|c| c[:name] === column_name}
          row_length = row_value.length
          column[:max_length] = row_length if row_length > column[:max_length]

          row_value
        end
      end

      def to_s
        headers = self.columns.map do |column|
          column[:name].to_s.pluralize.capitalize.ljust(column[:max_length])
        end
        justified_text = self.rows.map do |row|
          row.map.with_index do |row_value, index|
            column = columns[index]
            row_value.ljust(column[:max_length])
          end
        end
        "| #{headers.join(' | ')} |\n" \
        "| #{justified_text.join(' | ')} |\n"
      end
    end
  end
end