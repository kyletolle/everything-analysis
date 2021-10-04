# frozen_string_literal: true

require 'rubygems'
require 'pathname'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load
require "tactful_tokenizer"

module Everything
  class Analysis
    def run_and_print
      puts analytics_results
      puts all_results
    end

    def analytics_results
      completed_analytics.map do |piece_analytics|
        piece_title = piece_analytics[:piece_title]
        analytics_result = piece_analytics[:analytics]
          .map(&:to_s)
          .join("\n\n")

        "Analysis for Piece Titled: `#{piece_title}`\n\n" \
        "#{analytics_result}\n\n"
      end
    end

    def all_results
      piece_title = completed_analytics_for_all[:piece_title]
      analytics_result = completed_analytics_for_all[:analytics]
        .map(&:to_s)
        .join("\n\n")

      "Analysis for Piece Titled: `#{piece_title}`\n\n" \
      "#{analytics_result}\n\n"
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

    def completed_analytics_for_all
      piece_title = all_pieces_data[:piece_title]
      piece_markdown = all_pieces_data[:piece_markdown]
      analytics = analysis_to_perform.map do |analysis_klass|
        analysis_klass.new(piece_title: piece_title, piece_markdown: piece_markdown).run
      end
      { piece_title: piece_title, analytics: analytics }
    end

    def pieces_data_to_analyze
      pieces_to_analyze.map do |piece|
        {
          piece_title: piece.title,
          piece_markdown: piece.raw_markdown
        }
      end
    end

    def all_pieces_data
      all_markdown = pieces_to_analyze.map(&:raw_markdown).join('')
      {
        piece_title: "All Pieces at Once",
        piece_markdown: all_markdown
      }
    end

    def pieces_to_analyze
      piece_paths.map do |piece_path|
        Everything::Piece.new(piece_path)
      end
    end

    def piece_paths
      pieces_path = Pathname.new(Fastenv.everything_path).join(Fastenv.pieces_relative_path)
      Fastenv.pieces_globs.split(':').map do |glob|
        Dir.glob(glob, base: pieces_path).map do |path|
          Pathname.new(pieces_path).join(path)
        end
      end.flatten
    end

    def analysis_to_perform
      [
        Everything::Analysis::Analytics::CharacterFrequency,
        Everything::Analysis::Analytics::WhitespacePercentage,
        Everything::Analysis::Analytics::WordFrequency,
      ]
      # What other analytics?
      # Percentage of characters that is punctuation
      # Number of sentences. Check out https://stackoverflow.com/questions/25475581/ruby-split-text-into-sentences for a NLP that could be cool to use!
      # Number of paragraphs
      # Show character frequency as % instead of just raw total
      # Compare character frequency % for myself to the global %s to see what
      # characters I use more than other writers. Idea from Zach
      # Most common words per chapter - also from Zach
      # He mentions the plot he made from
      # https://github.com/ZWMiller/PythonProjects/blob/master/wordCounter/img/toaesWordCountPlot.png
    end

    ###################################################

    def tokenize
      model = TactfulTokenizer::Model.new
      first_piece_text = pieces_to_analyze.first.raw_markdown
      tokens = model.tokenize_text(first_piece_text)
      puts "Number of sentences: #{tokens.count}"
    end
  end
end

require_relative './analysis/analytics'
