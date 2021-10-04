# frozen_string_literal: true

module Everything
  class Analysis
    module Analytics
    end
  end
end

require_relative './analytics/character_frequency'
require_relative './analytics/whitespace_percentage'
require_relative './analytics/word_frequency'
require_relative './analytics/sentence_counter'
