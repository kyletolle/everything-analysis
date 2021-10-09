# frozen_string_literal: true

require 'stanford-core-nlp'
require_relative '../stanford_corenlp_pipeline'

module Everything
  class Analysis
    module Analytics
      class SentenceCounter < AnalyticBase
        def self.to_sym
          Analytics::SENTENCE_COUNTER
        end

        attr_accessor :sentences_count

        def name
          'Sentence Counter'
        end

        def sentences
          @sentences ||= begin
            # Following steps at
            # https://github.com/louismullie/stanford-core-nlp#using-the-latest-version-of-the-stanford-corenlp
            # helped get me get the stanford corenlp gem working!
            pipeline = Everything::Analysis::StanfordCorenlpPipeline.pipeline
            text = StanfordCoreNLP::Annotation.new(piece.raw_markdown)
            pipeline
              .tap{|o| puts "Starting annotation for #{piece.title}..." }
              .annotate(text)
              .tap{|o| puts "Finished annotation for #{piece.title}"}
            text.get(:sentences)
          end
        end

        def run
          @run_result ||= begin
            self.sentences_count = sentences.size
          end

          super
        end

        def create_table
          self.table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:sentence)
          table.add_row({ sentence: sentences_count.to_i })
        end
      end
    end
  end
end
