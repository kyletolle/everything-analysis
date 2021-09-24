module Everything
  class Analysis
    module Analytics
      class WhitespacePercentage
        attr_accessor :character_type_counts, :piece_markdown, :piece_title

        def name
          'Whitespace Percentage'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
        end

        def run
          self.character_type_counts = {
            whitespace: 0.0,
            non_whitespace: 0.0,
            total: 0.0,
          }

          piece_markdown.each_char do |char|
            character_type_counts[:total] += 1

            if char.match(/\s/)
              character_type_counts[:whitespace] += 1
            else
              character_type_counts[:non_whitespace] += 1
            end
          end

          self
        end

        def to_s
          total = character_type_counts[:total]
          whitespace = character_type_counts[:whitespace]
          non_whitespace = character_type_counts[:non_whitespace]
          percentage_whitespace = ((whitespace / total) * 100).ceil(1)
          percentage_non_whitespace = ((non_whitespace / total) * 100).ceil(1)

          "  #{name}\n" +
          "    Total: #{total}\n" +
          "    Whitespace: #{whitespace} (#{percentage_whitespace}%)\n" +
          "    Non-Whitespace: #{non_whitespace} (#{percentage_non_whitespace}%)"
        end
      end
    end
  end
end
