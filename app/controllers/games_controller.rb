require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    9.times { @grid << ('A'..'Z').to_a.sample }
    @start_time = Time.now
    @total_score = params["total_score"].to_f
  end

  def score
    words = params[:words]
    grid  = params[:grid].split("")
    @total_score = params[:total_score].to_f
    start_time = Time.parse(params[:start_time])
    end_time = Time.now
    wagon_dictionary = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{words}").read)
    words_attempt = words.upcase.chars


    if wagon_dictionary['found'] && words_attempt.all? { |letter| grid.include?(letter) }
      @score = (1 / (end_time - start_time)) * words_attempt.size
      @message = 'Well done !'
      @total_score += @score
    else
      @score = 0
      @total_score += @score
      @message = !wagon_dictionary['found'] ? 'not an english word' : 'not in the grid'
    end
  end
end
