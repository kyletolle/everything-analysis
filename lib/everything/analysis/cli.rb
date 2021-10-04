require 'everything/analysis'

module Everything
  class Analysis
    class CLI < Thor
      desc 'analyze', 'analyze a piece and print the results'
      def analyze
        analysis.run_and_print
      end

      desc 'tokenize', 'tokenize a piece with Tactful_Tokenizer'
      def tokenize
        analysis.tokenize
      end

      private

      def analysis
        Everything::Analysis.new
      end
    end
  end
end
