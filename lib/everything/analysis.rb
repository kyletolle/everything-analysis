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
      # puts analytics_results
      puts all_results
    end

    # Individual Pieces

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

    def completed_analytics
      @completed_analytics ||= pieces_data_to_analyze.map do |piece_data|
        piece_title = piece_data[:piece_title]
        piece_markdown = piece_data[:piece_markdown]
        analytics = Analytics::TO_RUN.map do |analysis_klass|
          analysis_klass.new(piece).run
        end
        { piece_title: piece_title, analytics: analytics }
      end.flatten
    end

    # TODO: update this
    def pieces_data_to_analyze
      pieces_to_analyze.map do |piece|
        {
          piece_title: piece.title,
          piece_markdown: piece.raw_markdown
        }
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
      # TODO: Add each of the analytics to the piece, then run all of them
      analytics = Analytics::TO_RUN.map do |analysis_klass|
        all_novel_text_piece.add_analytic(analysis_klass)
      end
      all_novel_text_piece.run_analytics
      all_novel_text_piece
    end

    def all_novel_text_piece
      @all_novel_text_piece ||= Everything::Piece.new('/tmp/all_pieces').tap do |piece|
        all_markdown = pieces_to_analyze.map(&:raw_markdown).join('')
        piece.raw_markdown = "# All Pieces at Once\n\n#{all_markdown}"
      end
    end

    # Other

    def pieces_to_analyze
      @pieces_to_analyze ||= piece_paths.map do |piece_path|
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
