module Everything
  class Analysis
    module Analytics
      class CharacterFrequency
        CHARACTERS_TO_IGNORE = [' ', "\n"]

        attr_accessor :character_frequency, :piece_markdown, :piece_title, :total_character_count

        def name
          'Character Frequency'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
          self.total_character_count = 0
        end

        def run
          self.character_frequency = {}
          characters_to_analyze.each do |char|
            self.total_character_count += 1

            character_frequency[char] ||= 0.0
            character_frequency[char] += 1
          end

          self
        end

        def to_s
          charcater_results = character_frequency
            .sort_by { |_,times_used| times_used }
            .reverse
            .map do |char, times_used|
              percentage_of_total = ((times_used / total_character_count) * 100).ceil(1)
              "#{char} - #{times_used.to_i} uses (#{percentage_of_total}%)"
            end
            .map{ |line| "    #{line}" }
            .join("\n")

          "  #{name}:\n" +
          "    Total characters: #{total_character_count}\n" +
          "#{charcater_results}"
        end

        def characters_to_analyze
          piece_markdown.each_char.reject { |char| CHARACTERS_TO_IGNORE.include?(char) }
        end
      end
    end
  end
end
