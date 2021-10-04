# frozen_string_literal: true


module Everything
  class Analysis
    module Analytics
      class ParagraphCounter
        attr_accessor :piece_markdown, :piece_title, :paragraphs_count

        def name
          'Paragraph Counter'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
        end

        def run
          self.paragraphs_count = piece_markdown.scan("\n\n").count + 1

          self
        end

        def to_s
          table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:paragraph)
          table.add_row({ paragraph: paragraphs_count.to_i.to_s })

          "  #{name}\n" \
          "#{table}"
        end
      end
    end
  end
end
