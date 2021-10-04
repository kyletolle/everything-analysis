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
          "  #{name}\n" \
          "    Count: #{paragraphs_count.to_i}"
        end
      end
    end
  end
end
