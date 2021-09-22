# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

module Everything
  class Analysis
    def run_and_print
      puts "hi!"
    end
  end
end
