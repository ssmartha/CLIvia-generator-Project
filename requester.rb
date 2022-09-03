module Requester
  
  def select_main_menu_action
    options=["random","scores","exit"]
    prompt= options.join(" | ")
    input=gets_option(prompt, options)
    input
    # prompt the user for the "random | scores | exit" actions
  end
  
  def ask_question(question)
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
    puts "Question: #{question[:question]}"
    question[:random_answers].each_with_index do |answer,pos|
      puts "#{pos+1}. #{answer}"
    end
    print "> "
    answer_id = gets.chomp.to_i
    answer_id = answer_id - 1
    # answer_id
    # show category and difficulty from question
    # show the question
    # show each one of the options
    # grab user input
  end

  def will_save?(score)
    print_score(score)
    puts "--------------------------------------------------"
    options=["y","n","Y"]
    prompt= "Do you want to save your score? (y/n)"
    input=gets_option(prompt, options)
    if input=="y" || input=="Y"
      name=get_user_name
      user_name= name == ""? "Anonymous": name
      data = {name: user_name, score: score}
    end
    data
    # show user's score
    # ask the user to save the score
    # grab user input
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
  end

  def get_user_name
    puts "Type the name to assign to the score"
    print "> "
    user_name=gets.chomp
    user_name
  end

  def gets_option(prompt, options)
    puts prompt
    input=""
    loop do
      print "> "
      input = gets.chomp
      break if options.include? (input)
      puts "invalid option"
    end
    input
    # prompt for an input
    # keep going until the user gives a valid option
  end

end
