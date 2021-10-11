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
      puts analytics_results
      puts all_results
    end

    # Individual Pieces

    def analytics_results
      completed_analytics.map do |piece|
        analytics_result = piece
          .analytics
          .values
          .map(&:to_s)
          .join("\n\n")

        "Analysis for Piece Titled: `#{piece.title}`\n\n" \
        "#{analytics_result}\n\n"
      end
    end

    # TODO: Update this name...
    def completed_analytics
      @completed_analytics ||= individual_pieces.each do |piece|
        Analytics::TO_RUN.map do |analysis_klass|
          piece.add_analytic(analysis_klass)
        end
        piece.run_analytics
      end
    end

    # All Pieces

    def all_results
      piece = completed_analytics_for_all
      analytics_result = piece
        .analytics
        .values
        .map(&:to_s)
        .join("\n\n")

      "Analysis for Piece Titled: `#{piece.title}`\n\n" \
      "#{analytics_result}\n\n"
    end

    # TODO: Update this name...
    def completed_analytics_for_all
      Analytics::TO_RUN.each do |analysis_klass|
        all_text_in_one_piece.add_analytic(analysis_klass)
      end
      all_text_in_one_piece.run_analytics
      all_text_in_one_piece
    end

    def all_text_in_one_piece
      @all_text_in_one_piece ||= Everything::Piece.new('/tmp/all_pieces').tap do |piece|
        all_markdown = individual_pieces.map(&:raw_markdown).join('')
        piece.raw_markdown = "# All Pieces at Once\n\n#{all_markdown}"
      end
    end

    # Other

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
