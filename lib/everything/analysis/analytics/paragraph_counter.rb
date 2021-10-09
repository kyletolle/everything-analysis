# frozen_string_literal: true


module Everything
  class Analysis
    module Analytics
      class ParagraphCounter < AnalyticBase
        attr_accessor :paragraphs_count

        def name
          'Paragraph Counter'
        end

        def run
          self.paragraphs_count = piece_markdown.scan("\n\n").count + 1

          super
        end

        def create_table
          self.table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:paragraph)
          table.add_row({ paragraph: paragraphs_count.to_i })
        end
      end
    end
  end
end
