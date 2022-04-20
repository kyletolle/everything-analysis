# frozen_string_literal: true

require 'rubygems'
require 'pathname'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load
require_relative './piece/analytics'

module Everything
  class Analysis
    def run_and_print
      run_analytics
      puts analytics_results_string
    end

    # TODO: Extract a "ConsoleOutput" class that's responsible for doing this
    # transformation here. So we can lay the groundwork for a HtmlOutput class
    # in the future that will allow us to start making graphs.
    def analytics_results_string
      individual_and_combined_pieces.map do |piece|
        analytics_result = piece
          .analytics
          .values
          .map(&:to_s)
          .join("\n\n")

        "Analysis for Piece Titled: `#{piece.title}`\n\n" \
        "#{analytics_result}\n\n"
      end
    end

    def run_analytics
      individual_and_combined_pieces.each do |piece|
        Analytics::TO_RUN.map do |analysis_klass|
          piece.add_analytic(analysis_klass)
        end
        piece.run_analytics
      end
    end

    def individual_and_combined_pieces
      @individual_and_combined_pieces ||= individual_pieces + [all_text_in_one_piece]
    end

    def all_text_in_one_piece
      @all_text_in_one_piece ||= Everything::Piece.new('/tmp/all_pieces').tap do |piece|
        all_markdown = individual_pieces.map(&:raw_markdown).join('')
        piece.raw_markdown = "# All Pieces at Once\n\n#{all_markdown}"
      end
    end

    def individual_pieces
      @individual_pieces ||= piece_paths.map do |piece_path|
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
  end
end

require_relative './analysis/analytics'
require_relative './analysis/table'
