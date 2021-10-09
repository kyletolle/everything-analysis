# frozen_string_literal: true

puts 'running Everything::Piece::Analytics core_ext'
Everything::Piece.class_eval do
  # Using `include` allows us to add the methods from the Analytics module as
  # instance methods.  Using `extend` instead would add them as class methods.
  include Everything::Piece::Analytics
end
