# frozen_string_literal: true

require 'everything'
require_relative './analytics/version'

puts 'loading Everything::Piece::Analytics module'

module Everything
  class Piece
    module Analytics
      # TODO: Add method for add_analytic, so the piece can keep track of the analytics itself.
      attr_accessor :analytics

      def add_analytic(analytic_klass)
        self.analytics ||= {}
        self.analytics[analytic_klass.to_sym] = analytic_klass.new(self)
      end

      def get_analytic_by_sym(analytic_sym)
        self.analytics[analytic_sym]
      end

      def run_analytics
        analytics.values.each(&:run)
      end
    end
  end
end

require_relative './analytics/core_ext'
