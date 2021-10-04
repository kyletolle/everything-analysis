# frozen_string_literal: true

require 'stanford-core-nlp'

module Everything
  class Analysis
    module Analytics
      class SentenceCounter
        class << self
          def pipeline
            @pipeline ||= begin
              StanfordCoreNLP.use :english
              StanfordCoreNLP.model_files = {}
              StanfordCoreNLP.default_jars = [
                'joda-time.jar',
                'xom.jar',
                'stanford-corenlp-3.5.0.jar',
                'stanford-corenlp-3.5.0-models.jar',
                'jollyday.jar',
                'bridge.jar'
              ]
              StanfordCoreNLP.load(:tokenize, :ssplit)
            end
          end
        end

        attr_accessor :piece_markdown, :piece_title, :sentences_count

        def name
          'Sentence Counter'
        end

        def initialize(piece_title:, piece_markdown:)
          self.piece_markdown = piece_markdown
          self.piece_title = piece_title
        end

        def run
          # Following steps at
          # https://github.com/louismullie/stanford-core-nlp#using-the-latest-version-of-the-stanford-corenlp
          # helped get me get the stanford corenlp gem working!
          self.class.pipeline
          text = StanfordCoreNLP::Annotation.new(piece_markdown)
          self.class.pipeline.annotate(text)
          self.sentences_count = text.get(:sentences).size

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
