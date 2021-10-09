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
        Everything::Analysis::Analytics::ParagraphCounter,
        Everything::Analysis::Analytics::SentenceCounter,
        Everything::Analysis::Analytics::WordFrequency,
        Everything::Analysis::Analytics::CharacterFrequency,
        Everything::Analysis::Analytics::WhitespacePercentage,
        Everything::Analysis::Analytics::PunctuationPercentage,
        Everything::Analysis::Analytics::SentimentAnalyzer
        Everything::Analysis::Analytics::WordCounter,
      ]
      # What other analytics?
      # Calculate Flesch Reading Ease or Flesch-Kincaid Grade Levels for each chapter and the book as a whole?
      # Calculate time to read for each chapter and the book as a whole?
      #   - Could use an approach like https://niram.org/read/ and assume 200 WPM is avg reading speed.
      #   - Also want to read https://w3collective.com/calculate-reading-time-javascript/
      #   - Then read https://cs.stackexchange.com/questions/57285/how-to-calculate-an-accurate-estimated-reading-time-of-text
      #   - And https://stackoverflow.com/questions/4216752/anyone-having-any-leads-on-a-reading-time-algorithm
      #   - And then it'd be nice to round the time from 3min 32 seconds to 3 and a half minutes using an approach like https://stackoverflow.com/questions/3278986/ago-date-time-functions-in-ruby-rails
      # Look at other nlp tools at
      #  - https://github.com/diasks2/ruby-nlp#word-count
      #  - https://github.com/arbox/nlp-with-ruby
      #  - https://github.com/louismullie/treat
      # Compare character frequency % for myself to the global %s to see what
      # characters I use more than other writers. Idea from Zach
      # Most common words per chapter - also from Zach
      # He mentions the plot he made from
      # https://github.com/ZWMiller/PythonProjects/blob/master/wordCounter/img/toaesWordCountPlot.png
    end
  end
end

require_relative './analysis/analytics'
require_relative './analysis/table'
