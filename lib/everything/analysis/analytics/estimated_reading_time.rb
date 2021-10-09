# frozen_string_literal: true


module Everything
  class Analysis
    module Analytics
      class EstimatedReadingTime
        AVERAGE_WORDS_READ_PER_MINUTE = 200.0

        attr_accessor :piece_markdown, :piece_title, :estimated_reading_time

        def name
          'Estimated Reading Time'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
        end

        def run
          word_frequency = Everything::Analysis::Analytics::WordCounter.new(piece_title: piece_title, piece_markdown: piece_markdown).run

          self.estimated_reading_time = word_frequency.total_word_count /  AVERAGE_WORDS_READ_PER_MINUTE

          self
        end

        def to_s
          table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:estimated_reading_time_in_minutes)
          table.add_row({ estimated_reading_time_in_minutes: self.estimated_reading_time.to_i.to_s })

          "  #{name}\n" \
          "#{table}"
        end
      end
    end
  end
end
