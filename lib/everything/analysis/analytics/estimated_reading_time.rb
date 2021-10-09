# frozen_string_literal: true

# Following example at https://stackoverflow.com/a/28667334/249218 for how to
# turn minutes into a human readable string
require 'action_view'
require 'action_view/helpers'
require 'active_support/core_ext/numeric/time'

include ActionView::Helpers::DateHelper

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
          table.add_columns(:estimated_reading_time)
          time_in_words = time_ago_in_words(Time.now - estimated_reading_time.minutes)
          table.add_row({ estimated_reading_time: time_in_words })

          "  #{name}\n" \
          "#{table}"
        end
      end
    end
  end
end
