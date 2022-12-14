# do not forget to require your gem dependencies
require "httparty"
require "json"
require "terminal-table"
require 'htmlentities'
require_relative "requester"
require_relative "presenter"
# do not forget to require_relative your local dependencies

class CliviaGenerator
  include HTTParty
  include Requester
  include Presenter
  # maybe we need to include a couple of modules?
  @@store_scores=[]
  def initialize(filename)
    @filename = filename
    @questions_data = load_questions
    @user_score = 0
    @@store_scores= File.open(@filename).size>0? parse_scores : []
    # we need to initialize a couple of properties here
  end

  def start
    parse_questions
    random_questions_key
    option_page
    # prompt the user for an action
    # keep going until the user types exit
  end

  
  # def random_trivia
  #   # load the questions from the api
  #   # questions are loaded, then let's ask them
  # end
  def option_page
    input=""
    until input=="exit"
      puts print_welcome
      input=select_main_menu_action
      case input
      when "random" then ask_questions
      when "scores" then print_scores
      end
    end
  end
  
  def ask_questions
    @questions_data.each do |question|
      answer_id=ask_question(question)
      @user_score=@user_score+1 if question[:correct_answer]==question[:random_answers][answer_id]
    end
    p @user_score
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
    score=@user_score*10
    data=will_save?(score)
    save(data) if data!=""
  end
  
  def save(data)
    @@store_scores.push(data)
    File.open(@filename,"w+") do |file|
      file.write(@@store_scores.to_json)
    end
    # write to file the scores data
  end

  def parse_scores
    scores_array=JSON.parse(File.read(@filename), symbolize_names: true)
    scores_array
    # get the scores data from file
  end

  def print_scores
    p @@store_scores
    table = Terminal::Table.new
    table.title= "Top Scores"
    table.headings=["Name","Score"]
    sorted_scores=@@store_scores.sort_by { |score| -score[:score]}
    table.rows = sorted_scores.map do |score|
      [score[:name],score[:score]]
    end
    puts table
  end

  def load_questions
    response = HTTParty.get("https://opentdb.com/api.php?amount=10")
    raise ResponseError.new(response) unless response.success?
    questions_hash=JSON.parse(response.body, symbolize_names: true)
    questions_hash[:results]
    # ask the api for a random set of questions
    # then parse the questions
  end
  
  def parse_questions
    @questions_data.each do |element|
      element[:question]=HTMLEntities.new.decode "#{element[:question]}"
      element[:correct_answer]=HTMLEntities.new.decode "#{element[:correct_answer]}"
      element[:answers]=[element[:correct_answer]]
      element[:incorrect_answers].each_with_index do |ele,pos|
        parsed_element=HTMLEntities.new.decode "#{ele}"
        element[:incorrect_answers][pos]=parsed_element
        element[:answers].push(parsed_element)
      end
    end
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end
  
  def random_questions_key
    @questions_data.each do |element|
      element[:random_answers]=[]
      limit=element[:answers].size - 1
      random_positions=(0..limit).to_a.sort{ rand() - 0.5 }
      (0..limit).each do |pos|
        element[:random_answers].push(element[:answers][random_positions[pos]])
      end
    end
  end
end

filename = ARGV.shift
ARGV.clear
filename = "store.json" if filename.nil?
p filename
trivia = CliviaGenerator.new(filename)
trivia.start
