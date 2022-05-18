# ZmgTEP Demo App

1.  Overview

The iOS App, in this repository, was created to connect to a JSONPlaceHolder site, download data and be shown and managed through ZmgTEP app functionalities. ZmgTEP is a simple app based on MVC architecture, the most fundamental design pattern, Model View Controller.  The app covers:
  - Service components.
  - Repository components.
  - Data and Business logic through the Model supported on Core Data.
  - Smple and easy to use UI, intuitive, based on usability.
  - Controllers look to suit as good as possible between the model and user interctions.


2.  Process Description

The app connects through an API service to extract, from JSONPlaceHolder site, 3 sets of data related to posts, post users and post comments.  Data is downloaded as JSON, transformed, decoded and saved it into 6 Core Data entities (post, post user, address, geo, company and comments).  
After it's saved it is loaded to a first viewcontroller where post titles are shown in a tableview.  There's a segmented control that present all posts or favorite posts.  If you swipe left on a post row you can delete it and automatically, all comments related to that post will be deleted.  There is a Delete All button at the bottom of the screen, which deletes all Core Data entities. The Navigation Bar right button Redownload the 3 sets of data, save them in 6 entities of Core Data and load all posts on a tableview.  Posts not seen have a blue dot identifier on the left side of the row.  If post is selected is considered as seen and the blue dot disappears.  If post is marked as favorite the blue dot is replace by a yellow star.  Posts are ordered by postId, but if there are favorites, favorites are positioned on top of the tablevlew ordered by postId.  The remaining posts are ordered by postId.  If tableview is segmented by Favorite, only favorites posts will be shown, ordered by postId (note: postId is the post identifier).
Second viewcontroller appears when a post is tapped, the selected post is marked as readed and saved in Core Data.  The screen shows the body of the post and some of the user information (name, email, phone, website), and a tableview in the lower part of the screen will list all the comments related to the selected post.  The Navigation Bar right button shows the favorite star button, to set the post as favorite.  Initially the star button is white and if it's pressed it turns to yellow and post is saved as favorite.


3.  Thid Party Libraries

No third party libraries were used.


4.  Requirements 

iOS 14.4 or higher.


5.  ToDo

Improvements can be made related to observers and performance optimization.  Other technologies, frameworks, design patterns and third party libraries can be applied.
