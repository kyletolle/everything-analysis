# frozen_string_literal: true

require 'stanford-core-nlp'

module Everything
  class Analysis
    module Analytics
      class SentenceCounter
        class << self
          def pipeline
            @pipeline ||= begin
              puts 'Starting loading Stanford CoreNLP pipeline...'
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
              .tap{|o| puts 'Finished loading Stanford CoreNLP pipeline' }
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
          @run_result ||= begin
            # Following steps at
            # https://github.com/louismullie/stanford-core-nlp#using-the-latest-version-of-the-stanford-corenlp
            # helped get me get the stanford corenlp gem working!
            self.class.pipeline
            text = StanfordCoreNLP::Annotation.new(piece_markdown)
            self.class.pipeline
              .tap{|o| puts "Starting annotation for #{piece_title}..." }
              .annotate(text)
              .tap{|o| puts "Finished annotation for #{piece_title}"}
            self.sentences_count = text.get(:sentences).size
          end

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
