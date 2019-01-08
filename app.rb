require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    # get game from session or create new one if not exist in a session
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  # Get game index|home page
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  
  # params[:guess].to_s[0] or its equivalent. to_s converts nil to the empty
  # string in case the form field was left blank (and therefore not included in params at all).
  # [0] grabs the first character only; for an empty string, it returns an empty string.
  post '/guess' do
    letter = params[:guess].to_s[0]  # strange but .to_s not converting here to string.
    if letter.class == NilClass || letter.empty?
      flash[:message] =  "Your input is empty." 
      redirect '/show'
    elsif @game.wrong_guesses.include?(letter) || @game.guesses.include?(letter)
      flash[:message] =  "You have already used that letter." 
      redirect '/show'
    elsif letter =~ /\W/
      flash[:message] = "Invalid guess."
      redirect '/show'
    else
      @game.guess(letter)
      redirect '/show'
    end
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  
  # show action that checks whether the game state it is about to show is 
  # actually a winning or losing state, and if so, it should redirect to the 
  # appropriate win or lose action.
  
  # While you're playing, what happens if you directly add /win to the end of
  # your app's URL? Make sure the player cannot cheat by simply visiting GET /win.
  # Consider how to modify the actions for win, lose, and show to prevent this behavior.
  get '/show' do
    redirect '/win' if @game.check_win_or_lose == :win
    redirect '/lose' if @game.check_win_or_lose == :lose
    erb :show
  end
  
  get '/win' do
    redirect '/show' if @game.check_win_or_lose == :play 
    redirect '/new' if @game.word.empty?  # the game state just before game start
    # "<!DOCTYPE html><html/><head></head><body><h1>Hello World</h1></body></html>" if  @game.word.empty? 
    erb :win
    
  end
  
  get '/lose' do
    redirect '/show' if @game.check_win_or_lose == :play
    redirect '/new' if @game.word.empty?  # the game state just before game start
    erb :lose
  end
  
end
