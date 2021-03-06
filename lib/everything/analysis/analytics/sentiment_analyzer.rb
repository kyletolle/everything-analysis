# frozen_string_literal: true

require 'sentiment_lib'
require_relative './sentence_counter'

module Everything
  class Analysis
    module Analytics
      # TODO: Split this into 2. Want to make sure this can reuse the to_s stuff
      # from the base class. But how do we allow it to reuse the sentiment
      # analysis from the 3rd party lib so that we don't need to run that
      # analysis twice? Make a SentimentBase class?
      class SentimentAnalyzer < AnalyticBase
        def self.to_sym
          Analytics::SENTIMENT_ANALYZER
        end

        attr_accessor :sentiments, :sentiment_categories

        def name
          'Sentiment Analyzer'
        end

        def sentences
          sentence_counter = piece.get_analytic_by_sym(Analytics::SENTENCE_COUNTER)
          sentence_counter.run.sentences
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

          super
        end

        def to_s
          total_sentences = sentences.size

          rating_table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 6)
          rating_table.add_columns(:rating, :count, :percentage)
          sentiments.each do |sentiment_rating, count|
            percent = ((count.to_f / total_sentences)*100).ceil(2)
            rating_table.add_row({ rating: sentiment_rating, count: count, percentage: percent })
          end

          category_table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 6)
          category_table.add_columns(:category, :count, :percentage)

          sentiment_categories.each do |category, count|
            percent = ((count.to_f / total_sentences)*100).ceil(2)
            category_table.add_row({ category: category, count: count, percentage: percent })
          end

          "  #{name}\n" \
          "    Sentiment Ratings: \n" \
          "#{rating_table}" \
          "    Sentiment Categories: \n" \
          "#{category_table}"
        end
      end
    end
  end
end
