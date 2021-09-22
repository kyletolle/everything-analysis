module Everything
  class Analysis
    module Analytics
      class CharacterFrequency
        CHARACTERS_TO_IGNORE = [' ', "\n"]

        attr_accessor :character_frequency, :piece_markdown, :piece_title

        def name
          'Character Frequency'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
        end

        def run
          self.character_frequency = {}
          characters_to_analyze.each do |char|
            character_frequency[char] ||= 0
            character_frequency[char] += 1
          end

          self
        end

        def to_s
          charcater_results = character_frequency
            .sort_by { |_,times_used| times_used }
            .reverse
            .map do |char, times_used|
              "`#{char}` was used #{times_used} times"
            end
            .map{ |line| "    #{line}" }
            .join("\n")
          "  #{name}:\n#{charcater_results}"
        end

        def characters_to_analyze
          piece_markdown.each_char.reject { |char| CHARACTERS_TO_IGNORE.include?(char) }
        end
      end
    end
  end
end
