require 'sentiment_lib'
require_relative './sentence_counter'

module Everything
  class Analysis
    module Analytics
      class SentimentAnalyzer
        attr_accessor :piece_markdown, :piece_title, :sentiments

        def name
          'Sentiment Analyzer'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
        end

        def sentences
          Everything::Analysis::Analytics::SentenceCounter
            .new(piece_title: piece_title, piece_markdown: piece_markdown)
            .sentences
        end

        def run
          @run_result ||= begin
            self.sentiments = {}
            # See https://github.com/nzaillian/sentiment_lib#usage for how to
            # use the sentiment analyzer
            analyzer = SentimentLib::Analyzer.new

            sentences.each do |sentence|
              sentiment = analyzer.analyze(sentence.to_s)
              sentiment = sentiment.to_f
              sentiments[sentiment] ||= 0
              sentiments[sentiment] += 1
            end
          end

          self
        end

        def to_s
          sentiments_string = sentiments
            .map { |k, v| "      #{v} sentences had the sentiment rating of #{k}" }
            .join("\n")

          "  #{name}\n" \
          "    Sentiments: \n#{sentiments_string}"
        end
      end
    end
  end
end
