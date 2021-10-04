# frozen_string_literal: true

require "tactful_tokenizer"

module Everything
  class Analysis
    module Analytics
      class SentenceCounter
        attr_accessor :piece_markdown, :piece_title, :sentences_count

        def name
          'Sentence Counter'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
        end

        def run
          model = TactfulTokenizer::Model.new
          tokens = model.tokenize_text(piece_markdown)
          self.sentences_count = tokens.count

          self
        end

        def to_s
          "  #{name}\n" \
          "    Count: #{sentences_count.to_i}"
        end
      end
    end
  end
end
