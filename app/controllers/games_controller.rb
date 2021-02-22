require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ("a" .. "z").to_a.sample }    
    return @letters    
  end

  def score        
    if in_the_grid?(params[:word], params[:letters]) && english_word?(params[:word])
      @message = "Congratulations! #{params[:word].upcase} is a valid English word!"
    elsif !in_the_grid?(params[:word], params[:letters])
      @message = "Sorry but #{params[:word].upcase} can't be built out of #{params[:letters].upcase}"
    else 
      @message = "Sorry but #{params[:word].upcase} does not seem to be an English word..."
    end    
  end

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    check_word_serialized = open(url).read
    check_word = JSON.parse(check_word_serialized)
    check_word['found']
  end

  def in_the_grid?(word, grid)    
    word_letters = word.split(//)
    game_grid = grid.split(" ")
    word_letters.each do |word_letter|         
      if game_grid.include?(word_letter)
        game_grid.delete(word_letter)
        word_letters.delete(word_letter)
      end
    end
    raise    
    return word_letters.size == 0    
  end
end
