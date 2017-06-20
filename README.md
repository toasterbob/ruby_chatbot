# Boaty Bob McBoatFace Chatbot and Todo List

Boaty Bob McBoatFace is a chatbot built on facebook utilizing Ruby on Rails with a postgresql database hosted on Heroku. It utilizes the facebook-messenger gem. It can store a simple todo list utilizing the following commands:

#### LIST
Displays current todo list.

#### LIST DONE
Displays items marked done.

#### #1 DONE
Choose the list item you want to mark done and it will remove it from the current todo list and now only display on the finished item list.  

#### ADD Buy milk
Adds an item to your current todo list.  

#### Help
Displays all of these commands

## Sample Interface
```text
User: LIST
Bot: You currently have 3 to-do items:
  #1: Redesign website
  #2: Learn Chatbot API
  #3: Clean room.
User: /#3 DONE
Bot: To-do item /#3 (“Clean room”) marked as done.
User: ADD Buy flight tickets
Bot: To-do item “Add flight tickets” added to list.
User: LIST
Bot: You currently have 3 to-do items:
  #1: Redesign website
  #2: Learn Chatbot API
  #3: Add flight tickets.
User: LIST DONE
Bot: You have 1 item marked as done:
  #1: Clean room (completed 20 seconds ago, on Jan 26, 2017, 13:54 PST)

User: HELP
BOT: To see Todo items type: LIST

To see completed items type: LIST DONE

To add an item type: ADD buy milk

To mark an item done type: #1 DONE

## Testing
I didn't think to install the RSpec gem when I created my models and controllers.  If I had done it first I could have automatically generated the matching spec frameworks as I created each model and controller.  

I would run tests for both the user and todos models and controllers.  I would create mock users and many mock todos for users.  Then I would run through listing todos, listing completed todos, marking todos as done and adding them for multiple users. I would also implement this for Easter Egg features.  

## Bonus Easter Eggs
Some of these connect to other APIs using the open-uri and json gems.  
```
###### Magic 8 ball: Will I get the job?

###### Roll dice

###### Chuck Norris

###### Mention Star Wars

###### Mention Rick Astley

###### Ask for advice

###### Ask for a quote

######  Ask it anything!  
I hooked it up to a conversational chatbot as well.  So anything else, ends up being answered by that.  
