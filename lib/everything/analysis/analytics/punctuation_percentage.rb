# frozen_string_literal: true

module Everything
  class Analysis
    module Analytics
      class PunctuationPercentage
        attr_accessor :piece_markdown, :piece_title, :punctuation_type_counts

        def name
          'Punctuation Percentage'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
        end

        def run
          self.punctuation_type_counts = {
            punctuation: 0.0,
            non_punctuation: 0.0,
            total: 0.0,
          }

          piece_markdown.each_char do |char|
            punctuation_type_counts[:total] += 1

            if char.match(/[[:punct:]]/)
              punctuation_type_counts[:punctuation] += 1
            else
              punctuation_type_counts[:non_punctuation] += 1
            end
          end

          self
        end

        def to_s
          table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:type, :use, :percentage)

          total = punctuation_type_counts[:total]
          punctuation = punctuation_type_counts[:punctuation]
          non_punctuation = punctuation_type_counts[:non_punctuation]
          percentage_punctuation = ((punctuation / total) * 100).ceil(1)
          percentage_non_punctuation = ((non_punctuation / total) * 100).ceil(1)

          table.add_row({ type: 'Total', use: total.to_i.to_s, percentage: '100' })
          table.add_row({ type: 'Puncutation', use: punctuation.to_i.to_s, percentage: percentage_punctuation.to_s })
          table.add_row({ type: 'Non-Punctuation', use: non_punctuation.to_i.to_s, percentage: percentage_non_punctuation.to_s })

          "  #{name}\n" \
          "#{table}"
        end
      end
    end
  end
end
