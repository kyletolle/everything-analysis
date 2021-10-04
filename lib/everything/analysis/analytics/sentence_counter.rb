# frozen_string_literal: true

require 'stanford-core-nlp'
require_relative '../stanford_corenlp_pipeline'

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

        def sentences
          @sentences ||= begin
            # Following steps at
            # https://github.com/louismullie/stanford-core-nlp#using-the-latest-version-of-the-stanford-corenlp
            # helped get me get the stanford corenlp gem working!
            pipeline = Everything::Analysis::StanfordCorenlpPipeline.pipeline
            text = StanfordCoreNLP::Annotation.new(piece_markdown)
            pipeline
              .tap{|o| puts "Starting annotation for #{piece_title}..." }
              .annotate(text)
              .tap{|o| puts "Finished annotation for #{piece_title}"}
            text.get(:sentences)
          end
        end

        def run
          @run_result ||= begin
            self.sentences_count = sentences.size
          end

          self
        end

        def to_s
          table = Everything::Analysis::Table.new(spaces_to_pad_at_beginning_of_each_line: 4)
          table.add_columns(:sentence)
          table.add_row({ sentence: sentences_count.to_i.to_s })

          "  #{name}\n" \
          "#{table}"
        end
      end
    end
  end
end
