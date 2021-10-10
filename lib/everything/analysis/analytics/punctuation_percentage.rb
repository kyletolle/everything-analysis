# frozen_string_literal: true

module Everything
  class Analysis
    module Analytics
      class PunctuationPercentage < AnalyticBase
        def self.to_sym
          Analytics::PUNCTUATION_PERCENTAGE
        end

        attr_accessor :punctuation_type_counts

        def name
          'Punctuation Percentage'
        end

        def initialize(piece)
          super

          self.punctuation_type_counts = {
            punctuation: 0.0,
            non_punctuation: 0.0,
            total: 0.0,
          }
        end

        def run
          @run_result ||= begin
            piece.raw_markdown.each_char do |char|
              punctuation_type_counts[:total] += 1

              if char.match(/[[:punct:]]/)
                punctuation_type_counts[:punctuation] += 1
              else
                punctuation_type_counts[:non_punctuation] += 1
              end
            end
          end

          super
        end

        def create_table
          self.table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:type, :use, :percentage)

          total = punctuation_type_counts[:total]
          punctuation = punctuation_type_counts[:punctuation]
          non_punctuation = punctuation_type_counts[:non_punctuation]
          percentage_punctuation = ((punctuation / total) * 100).ceil(1)
          percentage_non_punctuation = ((non_punctuation / total) * 100).ceil(1)

          table.add_row({ type: 'Total', use: total.to_i, percentage: '100' })
          table.add_row({ type: 'Puncutation', use: punctuation.to_i, percentage: percentage_punctuation })
          table.add_row({ type: 'Non-Punctuation', use: non_punctuation.to_i, percentage: percentage_non_punctuation })
        end
      end
    end
  end
end
