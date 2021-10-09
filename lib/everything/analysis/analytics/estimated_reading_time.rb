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
      class EstimatedReadingTime < AnalyticBase
        def self.to_sym
          Analytics::ESTIMATED_READING_TIME
        end

        AVERAGE_WORDS_READ_PER_MINUTE = 200.0

        attr_accessor :estimated_reading_time

        def name
          'Estimated Reading Time'
        end

        def run
          word_frequency = Everything::Analysis::Analytics::WordCounter.new(piece).run

          self.estimated_reading_time = word_frequency.total_word_count /  AVERAGE_WORDS_READ_PER_MINUTE

          super
        end

        def create_table
          self.table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:estimated_reading_time)
          time_in_words = time_ago_in_words(Time.now - estimated_reading_time.minutes)
          table.add_row({ estimated_reading_time: time_in_words })
        end
      end
    end
  end
end
