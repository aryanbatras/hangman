
class GuessApps

    def initialize
        @score = 0
      
        saved
        guess
        hangman
    end

    def saved
        print "Do you wanna load saved game? [y/n] "
        saved = gets.chomp

        if saved == 'y' 
           file = File.readlines("gamesave.csv", chomp: true)
           file.each do
                |line|
                temp = line.split(',')
                puts temp[1]
           end
           
           print "\n ur username? "
            user = gets.chomp
            loaded = false

            file.each do
                |line|
               temp = line.split(',')
            
                if temp[1] == user
                    loaded = true
                    @score = temp[0].to_i
                end
            end

            if loaded == true
                print "Game loadeed for #{user} \n"
                print "Your score was #{@score} \n"
            elsif loaded == false
                print "error wrong username \n"
                print "saved game not loaded \n"
            end


        elsif saved == 'n'
            print "new game \n"
            print "guess the word \n"
        end

    end
    def guess
        @arr = []
        file = File.readlines("guessapp.csv", chomp: true)
        file.each do
            |line|
            temp = line.split(" => ")
           @arr.push(temp)
        end
    end

    def start_mode
        arr = [1, 3, 3, 6, 6, 6]
        mode = arr.sample

        if mode == 6
            @guess = 6
            @play = 'easy'
            print "you got easy mode: 6 guess\n"
        elsif mode == 3
            @guess = 3
            @play = 'hard'
            print "you got hard mode: 3 guess \n"
        elsif mode == 1
            @guess = 1
            @play = 'luck'
            print "you got luck mode: 1 guess \n"
        end        
    end

    def hangman
        start_mode
        @arr_store = ['-']

        arrdraw0 = ['_','_','_','_','_','_'].join('')
        arrdraw1 = ['|',' ',' ',' ',' ',' '].join('')
        arrdraw2 = ['|',' ',' ',' ',' ',' '].join('')
        arrdraw3 = ['|',' ',' ',' ',' ',' '].join('')
        arrdraw4 = ['|',' ',' ',' ',' ',' '].join('')
        arrdraw5 = ['|',' ',' ',' ',' ',' '].join('')
        arrdraw6 = ['|',' ',' ',' ',' ',' '].join('')


        while(@guess != 0) do

            if @play == 'easy'
            
                if @guess == 6
                    arrdraw1[4] = '|'
                elsif @guess == 5
                    arrdraw2[4] = '|'
                elsif @guess == 4 
                    arrdraw3[4] = 'O'
                elsif @guess == 3
                    arrdraw4[4] = '|'
                elsif @guess == 2
                    arrdraw3[3] = '\\'
                    arrdraw3[5] = '/ '
                elsif @guess == 1
                    arrdraw5[3] = '/ '
                    arrdraw5[4] = ' \\'
                end

            elsif @play == 'hard'

                if @guess == 3
                    arrdraw1[4] = '|'
                    arrdraw2[4] = '|'
                elsif @guess == 2
                    arrdraw3[4] = 'O'
                    arrdraw4[4] = '|'
                elsif @guess == 1
                    arrdraw3[3] = '\\'
                    arrdraw3[5] = '/ '
                    arrdraw5[3] = '/ '
                    arrdraw5[4] = ' \\'
                end

            elsif @play == 'luck'

                if @guess == 1
                    arrdraw1[4] = '|'
                    arrdraw2[4] = '|'
                    arrdraw3[4] = 'O'
                    arrdraw4[4] = '|'
                    arrdraw3[3] = '\\'
                    arrdraw3[5] = '/ '
                    arrdraw5[3] = '/ '
                    arrdraw5[4] = ' \\'
                end

            end

            if @arr_store.all? {|o| o == 'o'} == true
                
                arrdraw0 = ['_','_','_','_','_','_'].join('')
                arrdraw1 = ['|',' ',' ',' ',' ',' '].join('')
                arrdraw2 = ['|',' ',' ',' ',' ',' '].join('')
                arrdraw3 = ['|',' ',' ',' ',' ',' '].join('')
                arrdraw4 = ['|',' ',' ',' ',' ',' '].join('')
                arrdraw5 = ['|',' ',' ',' ',' ',' '].join('')
                arrdraw6 = ['|',' ',' ',' ',' ',' '].join('')
    
                arrdraw4[3] = '\\ '
                arrdraw4[4] = 'o'
                arrdraw4[5] = '/'
                arrdraw5[4] = '|'
                arrdraw6[3] = '/ '
                arrdraw6[5] = '\\'
           end

           puts arrdraw0
           puts arrdraw1
           puts arrdraw2
           puts arrdraw3
           puts arrdraw4
           puts arrdraw5
           puts arrdraw6

            break if @arr_store.all? {|o| o == 'o'}

            guess_text
            @guess -= 1

        end

        if @arr_store.all? {|o| o == 'o'} == true
            print "You win, Man is saved \n \n"
            @score += 1
            play_again

        elsif @arr_store.all? {|o| o == 'o'} == false
            print "You lose, Man is hanged \n \n" 
            @score -= 1
            play_again
        end
    end


    def guess_text

        sample = @arr.sample
        
        answer = sample[1]
        answer = answer.split('')

        hint_text = sample[0]
        print "\n #{hint_text}"
        print "\n Guess "
        
        user_input = gets.chomp
        user_input = user_input.split('')
        
        ans_length = answer.length
        user_length = user_input.length

        arr = []
        ans_length.times do
            arr.push('-')
        end

        temp = 0
        user_input.each {
            |letter|
            if answer[temp] == letter
                arr[temp] = 'o'
            end
            temp += 1
        }

        num = 0
        user_input.each {
            |letter|
            if answer.include?(letter) == true && arr[num] != 'o'
                arr[num] = 'x'
            end
            num += 1
        }

        @arr_store = arr
        puts "       #{arr.join('')}"


        print "\n"
        length_diff = ans_length - user_length
        if length_diff > 0
           add_length = length_diff
        elsif length_diff < 0
            reduce_length = length_diff
        end


       if @arr_store.all? {|o| o == 'o'} == false
            if length_diff > 0
                print "Wrong Guess, add #{length_diff} letters \n"
                print "Press Enter ..."
                continue = gets.chomp
            elsif length_diff < 0
                print "Wrong Guess, reduce #{length_diff} letters \n"
                print "Press Enter ..."
                continue = gets.chomp
            end
        end
    end


    def play_again
        print "Score #{@score} \n"
        print "Do you wanna play again? [y/n] "
        play = gets.chomp

        print "Do you wanna save your progress? [y/n] "
        save = gets.chomp

        if save == 'y'
            print "username "
            username = gets.chomp

                f = File.open('gamesave.csv', "a")
                f.write("\n#{@score},#{username}")
                f.close
                print "score saved as #{username} \n"


        elsif save == 'n'
            print "not saved \n" 
        end

        if play == 'y'
            hangman
        elsif play == 'n'
            print "exit \n"
        end
    end

end


class GameStart
    def initialize

        print "
        Save the man by guessing

        x means same num
        o means same pos \n"

        print "\n Press Enter to START \n"
        start = gets.chomp

        guess_apps = GuessApps.new
    end
end
start = GameStart.new