# frozen_string_literal: true

require 'sentiment_lib'
require_relative './sentence_counter'

module Everything
  class Analysis
    module Analytics
      class SentimentAnalyzer
        attr_accessor :piece_markdown, :piece_title, :sentiments, :sentiment_categories

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
            self.sentiment_categories = {
              negative: 0,
              neutral: 0,
              positive: 0,
            }
            # See https://github.com/nzaillian/sentiment_lib#usage for how to
            # use the sentiment analyzer
            analyzer = SentimentLib::Analyzer.new(strategy: SentimentLib::Analysis::Strategies::BasicDictStrategy.new)

            sentences.each do |sentence|
              sentiment = analyzer.analyze(sentence.to_s)
              sentiment = sentiment.to_f.ceil(0)
              sentiments[sentiment] ||= 0
              sentiments[sentiment] += 1
            end

            self.sentiments = sentiments
              .sort{ |a, b| a <=> b }

            sentiments.each do |sentiment, count|
              category = case sentiment
                when -Float::INFINITY..-1
                  :negative
                when 0
                  :neutral
                when 1..Float::INFINITY
                  :positive
              end
              self.sentiment_categories[category] ||= 0
              self.sentiment_categories[category] += count
            end
          end

          self
        end

        def to_s
          total_sentences = sentences.size

          sentiments_string = sentiments
            .map do |sentiment_rating, count|
              percent = ((count.to_f / total_sentences)*100).ceil(2)
              "      #{count} sentences had the sentiment rating of #{sentiment_rating} (#{percent}%) "
            end
            .join("\n")

          category_counts = sentiment_categories
            .map do |category, count|
              percent = ((count.to_f / total_sentences)*100).ceil(2)
              "      #{count} sentences were #{category} (#{percent}%)"
            end
            .join("\n")

          "  #{name}\n" \
          "    Sentiments: \n#{sentiments_string}\n\n" \
          "    Sentiment Categories: \n#{category_counts}"
        end
      end
    end
  end
end
