
module Everything
  class Analysis
    class StanfordCorenlpPipeline
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
    end
  end
end