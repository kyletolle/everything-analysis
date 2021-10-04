# frozen_string_literal: true

module Everything
  class Analysis
    module Analytics
      class WordFrequency
        NON_WORD_REGEX = /\W/
        DIGITS_REGEX = /\d/
        REGEX_PATTERNS_TO_IGNORE = [NON_WORD_REGEX, DIGITS_REGEX]

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
          self.word_frequency = {}
          words_to_analyze.each do |word|
            self.total_word_count += 1

            word_frequency[word] ||= 0.0
            word_frequency[word] += 1
          end

          self
        end

        def to_s
          max_word_length = word_frequency.map{|word, _| word.length}.max
          max_times_used_length = word_frequency.map { |_, times_used| times_used.to_i.to_s.length }.max

          word_results = word_frequency
            .sort_by { |_,times_used| times_used }
            .reverse
            .map do |word, times_used|
              percentage_of_total = ((times_used / total_word_count) * 100).ceil(1)
              word_text = word.ljust(max_word_length)
              times_used_text = times_used.to_i.to_s.ljust(max_times_used_length)
              "    #{word_text} | #{times_used_text} uses (#{percentage_of_total}%)"
            end
            .join("\n")


          "  #{name}:\n" \
          "    Total words: #{total_word_count}\n" \
          "#{word_results}"
        end

        def words_to_analyze
          piece_markdown.split(/\b/).map(&:downcase).reject do |w|
            REGEX_PATTERNS_TO_IGNORE.any?{|pattern| w.match(pattern )}
          end
        end
      end
    end
  end
end
