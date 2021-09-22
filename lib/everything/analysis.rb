# frozen_string_literal: true

require 'rubygems'
require 'pathname'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

module Everything
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

    class WhitespacePercentage
      attr_accessor :character_type_counts, :piece_markdown, :piece_title

      def name
        'Whitespace Percentage'
      end

      def initialize(piece_title:, piece_markdown:)
        self.piece_markdown = piece_markdown
        self.piece_title = piece_title
      end

      def run
        self.character_type_counts = {
          whitespace: 0.0,
          non_whitespace: 0.0,
          total: 0.0,
        }

        piece_markdown.each_char do |char|
          character_type_counts[:total] += 1

          if char.match(/\s/)
            character_type_counts[:whitespace] += 1
          else
            character_type_counts[:non_whitespace] += 1
          end
        end

        self
      end

      def to_s
        total = character_type_counts[:total]
        whitespace = character_type_counts[:whitespace]
        non_whitespace = character_type_counts[:non_whitespace]
        percentage_whitespace = ((whitespace / total) * 100).ceil(1)
        percentage_non_whitespace = ((non_whitespace / total) * 100).ceil(1)

        "  #{name}\n    % Whitespace: #{percentage_whitespace}\n    % Non-Whitespace: #{percentage_non_whitespace}"
      end
    end
  end

  class Analysis
    def run_and_print
      puts analytics_results
    end

    def analytics_results
      completed_analytics.map do |piece_analytics|
        piece_title = piece_analytics[:piece_title]
        analytics_result = piece_analytics[:analytics]
          .map(&:to_s)
          .join("\n\n")

        "Analysis for Piece Titled: `#{piece_title}`\n\n" + analytics_result
      end
    end

    def completed_analytics
      pieces_data_to_analyze.map do |piece_data|
        piece_title = piece_data[:piece_title]
        piece_markdown = piece_data[:piece_markdown]
        analytics = analysis_to_perform.map do |analysis_klass|
          analysis_klass.new(piece_title: piece_title, piece_markdown: piece_markdown).run
        end
        { piece_title: piece_title, analytics: analytics }
      end.flatten
    end

    def pieces_data_to_analyze
      pieces_to_analyze.map do |piece|
        {
          piece_title: piece.title,
          piece_markdown: piece.raw_markdown
        }
      end
    end

    def pieces_to_analyze
      piece_paths.map do |piece_path|
        Everything::Piece.new(piece_path)
      end
    end

    def piece_paths
      [
        Pathname.new(Fastenv.everything_path).join(Fastenv.piece_relative_path_to_analyze)
      ]
    end

    def analysis_to_perform
      [
        Everything::Analytics::CharacterFrequency,
        Everything::Analytics::WhitespacePercentage,
      ]
      # What other analytics?
      # Percentage characters that's punctuation
      # Percentage whitespace
      # Number of words
      # Number of sentences
      # Number of paragraphs
    end
  end
end
