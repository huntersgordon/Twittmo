#Written By Hunter Gordon on May 8, 2018. UC Berkeley Computer Science
#Twittmo: venmo plus twitter. Automatically venmos a penny when somebody
#tweets their venmo username at you.
while
     #check for new tweets at you every 30 seconds. (API Limit is 180 calls every 15 mins)
     sleep 30;
     do
          #get the last tweet to me
          a=$(t replies -c -n 1 | cut -d , -f 4 | sed '1d' | sed 's/@\djhunty //g');
          #cut off any words in the that tweet after a space character.
          #example: "@huntersgordon is my username" returns "@huntersgordon"
          username=$(echo $a | cut -f1 -d" ");
          #check if this person has already been venmo'd.
          if grep -q $username paid_users.txt;
               then
                    echo $username' has already been venmoed.';
               #if they havent been venmo'd:
               else
                    #Pay this person and add them to the list of paid users. also check
                    #whether or not they entered their username with an '@' symbol.
                    if [ $(echo $username | cut -c1-1) = "@" ];
                         then
                              echo "first character is an at symbol"; echo $username >> paid_users.txt;
                              venmo pay $username 0.01 "thanks for the tweet!";
                         else
                              echo "first character is not an at symbol"; echo @$username >> paid_users.txt ;
                              venmo pay "@"$username 0.01 "thanks for the tweet!";
                    fi ;
          fi;
done
