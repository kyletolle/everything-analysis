# frozen_string_literal: true

require 'words_counted'
require_relative './sentence_counter'

module Everything
  class Analysis
    module Analytics
      class WordFrequency < AnalyticBase
        def self.to_sym
          Analytics::WORD_FREQUENCY
        end

        attr_accessor :word_frequency, :total_unique_words

        def name
          'Word Frequency'
        end

        def initialize(piece)
          super

          self.total_unique_words = 0
        end

        def run
          self.word_frequency = word_counter.token_frequency
          self.total_unique_words = word_counter.uniq_token_count

          super
        end

        def word_counter
          @word_counter ||= WordsCounted.count(text_to_analyze)
        end

        def text_to_analyze
          @text_to_analyze ||= piece.raw_markdown.gsub('---', ' ')
        end

        def create_table
          self.table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:word, :uses, :percentage)
          table.add_row({ word: 'Total Unique Words', uses: total_unique_words, percentage: '100' })

          word_frequency
            .map do |word, times_used|
              percentage_of_total = ((times_used.to_f / total_unique_words) * 100).ceil(1)
              table.add_row({ word: word, uses: times_used.to_i, percentage: percentage_of_total })
            end
        end
      end
    end
  end
end
