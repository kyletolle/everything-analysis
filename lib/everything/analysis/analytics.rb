# frozen_string_literal: true

require_relative './analytics/analytic_base'
require_relative './analytics/character_frequency'
require_relative './analytics/estimated_reading_time'
require_relative './analytics/paragraph_counter'
require_relative './analytics/punctuation_percentage'
require_relative './analytics/sentence_counter'
require_relative './analytics/sentiment_analyzer'
require_relative './analytics/whitespace_percentage'
require_relative './analytics/word_frequency'
require_relative './analytics/word_counter'

module Everything
  class Analysis
    module Analytics
      # What other analytics?
      # Calculate Flesch Reading Ease or Flesch-Kincaid Grade Levels for each chapter and the book as a whole?
      # Calculate time to read for each chapter and the book as a whole?
      #   - Could use an approach like https://niram.org/read/ and assume 200 WPM is avg reading speed.
      #   - Also want to read https://w3collective.com/calculate-reading-time-javascript/
      #   - Then read https://cs.stackexchange.com/questions/57285/how-to-calculate-an-accurate-estimated-reading-time-of-text
      #   - And https://stackoverflow.com/questions/4216752/anyone-having-any-leads-on-a-reading-time-algorithm
      #   - And then it'd be nice to round the time from 3min 32 seconds to 3 and a half minutes using an approach like https://stackoverflow.com/questions/3278986/ago-date-time-functions-in-ruby-rails
      # Look at other nlp tools at
      #  - https://github.com/diasks2/ruby-nlp#word-count
      #  - https://github.com/arbox/nlp-with-ruby
      #  - https://github.com/louismullie/treat
      # Lemmatize all the words and see what number of unique root are used, and their frequency too.
      # Compare character frequency % for myself to the global %s to see what
      # characters I use more than other writers. Idea from Zach
      # Most common words per chapter - also from Zach
      # He mentions the plot he made from
      # https://github.com/ZWMiller/PythonProjects/blob/master/wordCounter/img/toaesWordCountPlot.png
      TO_RUN = [
        CharacterFrequency,
        EstimatedReadingTime,
        ParagraphCounter,
        PunctuationPercentage,
        SentenceCounter,
        SentimentAnalyzer,
        WhitespacePercentage,
        WordCounter,
        WordFrequency,
      ]
    end
  end
end
