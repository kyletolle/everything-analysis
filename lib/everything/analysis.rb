# frozen_string_literal: true

require 'rubygems'
require 'pathname'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

module Everything
  module Analytics
    class CharacterFrequency
      attr_accessor :character_frequency, :piece_markdown, :piece_title

      def initialize(piece_title:, piece_markdown:)
        self.piece_markdown = piece_markdown
        self.piece_title = piece_title
      end

      def run
        self.character_frequency = {}
        piece_markdown.each_char do |char|
          character_frequency[char] ||= 0
          character_frequency[char] += 1
        end
        return self
      end

      def to_s
        character_frequency
          .sort_by { |_,times_used| times_used }
          .reverse
          .map do |char, times_used|
            "`#{char}` was used #{times_used} times"
          end
          .map{ |line| "  #{line}" }
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
          .join("\n")

        puts "Analysis for Piece Titled: `#{piece_title}`"
        puts analytics_result
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
      [Everything::Analytics::CharacterFrequency]
    end
  end
end
