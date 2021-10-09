# frozen_string_literal: true

require 'words_counted'
require_relative './sentence_counter'

module Everything
  class Analysis
    module Analytics
      class WordCounter < AnalyticBase
        attr_accessor :word_frequency, :total_word_count

        def name
          'Word Count'
        end

        def initialize(piece_title:, piece_markdown:)
          super

          self.total_word_count = 0
        end

        def run
          self.total_word_count = word_counter.token_count

          super
        end

        def word_counter
          @word_counter ||= WordsCounted.count(text_to_analyze)
        end

        def text_to_analyze
          @text_to_analyze ||= piece_markdown.gsub('---', ' ')
        end

        def create_table
          self.table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:total_words)
          table.add_row({ total_words: total_word_count })
        end
      end
    end
  end
end
