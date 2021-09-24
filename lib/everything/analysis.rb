# frozen_string_literal: true

require 'rubygems'
require 'pathname'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

module Everything
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
        Everything::Analysis::Analytics::CharacterFrequency,
        Everything::Analysis::Analytics::WhitespacePercentage,
        Everything::Analysis::Analytics::WordFrequency,
      ]
      # What other analytics?
      # Percentage of characters that is punctuation
      # Number of words
      # Number of sentences
      # Number of paragraphs
      # Show character frequency as % instead of just raw total
      # Compare character frequency % for myself to the global %s to see what
      # characters I use more than other writers. Idea from Zach
      # Most common words per chapter - also from Zach
      # He mentions the plot he made from
      # https://github.com/ZWMiller/PythonProjects/blob/master/wordCounter/img/toaesWordCountPlot.png
    end
  end
end

require_relative './analysis/analytics'
