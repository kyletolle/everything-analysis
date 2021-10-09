# frozen_string_literal: true

require 'everything'
require_relative './analytics/version'

puts 'loading Everything::Piece::Analytics module'

module Everything
  class Piece
    module Analytics
      # TODO: Add method for add_analytic, so the piece can keep track of the analytics itself.

      attr_accessor :analytics

      def add_analytic(analytic)
        puts 'todo'
        # analytic[analytic.to_sym] = analytic
      end
    end
  end
end

require_relative './analytics/core_ext'
