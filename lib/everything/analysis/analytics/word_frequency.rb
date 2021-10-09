# frozen_string_literal: true

require 'words_counted'
require_relative './sentence_counter'

module Everything
  class Analysis
    module Analytics
      class WordFrequency
        attr_accessor :word_frequency, :piece_markdown, :piece_title, :total_unique_words

        def name
          'Word Frequency'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
          self.total_unique_words = 0
        end

        def run
          self.word_frequency = word_counter.token_frequency
          self.total_unique_words = word_counter.uniq_token_count

          self
        end

        def word_counter
          @word_counter ||= WordsCounted.count(text_to_analyze)
        end

        def text_to_analyze
          @text_to_analyze ||= piece_markdown.gsub('---', ' ')
        end

        def to_s
          max_word_length = word_frequency.map{|word, _| word.length}.max
          max_times_used_length = word_frequency.map { |_, times_used| times_used.to_i.to_s.length }.max

          table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:word, :uses, :percentage)
          table.add_row({ word: 'Total Unique Words', uses: total_unique_words, percentage: '100' })

          word_frequency
            .map do |word, times_used|
              percentage_of_total = ((times_used.to_f / total_unique_words) * 100).ceil(1)
              table.add_row({ word: word, uses: times_used.to_i, percentage: percentage_of_total })
            end

          "  #{name}\n" \
          "#{table}"
        end
      end
    end
  end
end
