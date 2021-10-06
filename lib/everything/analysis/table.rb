require 'active_support/core_ext/string/inflections'

module Everything
  class Analysis
    class Table
      BOX_UPPER_LEFT = '┏'
      BOX_UPPER_INTERSECTION = '┳'
      BOX_UPPER_RIGHT = '┓'
      BOX_MIDDLE_LEFT = '┣'
      BOX_MIDDLE_INTERSECTION = '╋'
      BOX_MIDDLE_RIGHT = '┫'
      BOX_LOWER_LEFT = '┗'
      BOX_LOWER_INTERSECTION = '┻'
      BOX_LOWER_RIGHT = '┛'
      BOX_HORIZONTAL_DASH = '━'
      BOX_VERTICAL_DASH = '┃'

      attr_accessor :columns, :rows, :spaces_to_pad_at_beginning_of_each_line

      def initialize(spaces_to_pad_at_beginning_of_each_line:)
        self.spaces_to_pad_at_beginning_of_each_line = spaces_to_pad_at_beginning_of_each_line
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


        line_padding = ' ' * spaces_to_pad_at_beginning_of_each_line

        justified_texts = self.rows.map do |row|
          "#{line_padding}#{BOX_VERTICAL_DASH} " + row.map.with_index do |row_value, index|
            column = columns[index]
            row_value.ljust(column[:max_length])
          end.join(" #{BOX_VERTICAL_DASH} ") + " #{BOX_VERTICAL_DASH}"
        end

        header_text = "#{BOX_VERTICAL_DASH} #{headers.join(" #{BOX_VERTICAL_DASH} ")} #{BOX_VERTICAL_DASH}\n"
        # box_horizontal_line = BOX_HORIZONTAL_DASH * (header_text.length - 3)
        box_top_line = self.columns.map do |column|
          BOX_HORIZONTAL_DASH * (column[:max_length] + 2)
        end.join(BOX_UPPER_INTERSECTION)
        top_line_spacer = "#{line_padding}#{BOX_UPPER_LEFT}#{box_top_line}#{BOX_UPPER_RIGHT}\n"
        box_middle_line = self.columns.map do |column|
          BOX_HORIZONTAL_DASH * (column[:max_length] + 2)
        end.join(BOX_MIDDLE_INTERSECTION)
        middle_line_spacer = "#{line_padding}#{BOX_MIDDLE_LEFT}#{box_middle_line}#{BOX_MIDDLE_RIGHT}\n"
        box_lower_line = self.columns.map do |column|
          BOX_HORIZONTAL_DASH * (column[:max_length] + 2)
        end.join(BOX_LOWER_INTERSECTION)
        bottom_line_spacer = "#{line_padding}#{BOX_LOWER_LEFT}#{box_lower_line}#{BOX_LOWER_RIGHT}\n"

        "#{top_line_spacer}" \
        "#{line_padding}#{header_text}" \
        "#{middle_line_spacer}" \
        "#{justified_texts.join("\n")}\n" \
        "#{bottom_line_spacer}\n"
      end
    end
  end
end
