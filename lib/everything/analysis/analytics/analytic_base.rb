# frozen_string_literal: true

module Everything
  class Analysis
    module Analytics
      class AnalyticBase
        attr_accessor :piece, :table

        def name
          raise NotImplementedError('Needs to be implemented by the extending class')
        end

        def initialize(piece)
          self.piece = piece
        end

        def run
          self
        end

        def create_table
          raise NotImplementedError('Needs to be implemented by the extending class')
        end

        def to_s
          create_table

          "  #{name}\n" \
          "#{self.table}"
        end
      end
    end
  end
end
