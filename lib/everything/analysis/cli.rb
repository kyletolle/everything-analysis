require 'everything/analysis'

module Everything
  class Analysis
    class CLI < Thor
      desc 'analyze', 'analyze a piece and print the results'
      def analyze
        analysis.run_and_print
      end

      desc 'table', 'display a test for the new table output'
      def table
        new_table = Everything::Analysis::Table.new
        new_table.add_columns :character, :usage
        new_table.add_row({ character: 'a', usage: 50.to_s })
        puts new_table.to_s
      end

      private

      def analysis
        Everything::Analysis.new
      end
    end
  end
end
