# require_relative "clivia_generator"
module Presenter
  def print_welcome
    ["###################################",
      "#   Welcome to Clivia Generator   #",
      "###################################"
    ].join("\n")
  end

  def print_score(score)
    puts "Well done! Your score is #{score}"
  end

end
