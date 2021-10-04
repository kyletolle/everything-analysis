# frozen_string_literal: true

require 'words_counted'
require_relative './sentence_counter'

module Everything
  class Analysis
    module Analytics
      class WordFrequency
        attr_accessor :word_frequency, :piece_markdown, :piece_title, :total_word_count

        def name
          'Word Frequency'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
          self.total_word_count = 0
        end

        def run
          self.word_frequency = word_counter.token_frequency
          self.total_word_count = word_counter.uniq_token_count

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

          word_results = word_frequency
            .map do |word, times_used|
              percentage_of_total = ((times_used.to_f / total_word_count) * 100).ceil(1)
              word_text = word.ljust(max_word_length)
              times_used_text = times_used.to_i.to_s.ljust(max_times_used_length)
              "    #{word_text} | #{times_used_text} uses (#{percentage_of_total}%)"
            end
            .join("\n")


          "  #{name}:\n" \
          "    Total words: #{total_word_count}\n" \
          "#{word_results}"
        end
      end
    end
  end
end
