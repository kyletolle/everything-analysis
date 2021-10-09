# frozen_string_literal: true

module Everything
  class Analysis
    module Analytics
      class CharacterFrequency < AnalyticBase
        CHARACTERS_TO_IGNORE = [' ', "\n"]

        attr_accessor :character_frequency, :total_character_count

        def name
          'Character Frequency'
        end

        def initialize(piece_title:, piece_markdown:)
          super

          self.total_character_count = 0
          self.character_frequency = {}
        end

        def run
          characters_to_analyze.each do |char|
            self.total_character_count += 1

            character_frequency[char] ||= 0.0
            character_frequency[char] += 1
          end

          super
        end

        def create_table
          max_times_used_length = character_frequency.map{|_, times_used| times_used.to_i.to_s.length }.max

          self.table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:character, :uses, :percentage)

          table.add_row({ character: 'Total Characters', uses: total_character_count, percentage: '100' })
          character_frequency
            .sort_by { |_,times_used| times_used }
            .reverse
            .each do |char, times_used|
              percentage_of_total = ((times_used / total_character_count) * 100).ceil(1)
              table.add_row({ character: char, uses: times_used.to_i, percentage: percentage_of_total })
            end
        end

        def characters_to_analyze
          piece_markdown.each_char.reject { |char| CHARACTERS_TO_IGNORE.include?(char) }
        end
      end
    end
  end
end
