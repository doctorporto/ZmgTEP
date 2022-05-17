# ZmgTEP Demo App

1.  Overview

The iOS App in this repository is created to connect with JSONPlaceHolder site and download data shown through ZmgTEP app functionalities. ZmgTEP a is simple app based on MVC architecture, the most fundamental design pattern, Model View Controller.  The app is form of:
  - Service components.
  - Repository components.
  - Bata and Business logic through the Model supported on Core Data.
  - Smple and easy to use UI, intuitive, based on usability.
  - Controllers look to suit as good as possible between the model and user interctions.


2.  Process Description

The app connects through an API service to extract, from JSONPlaceHolder site, 3 sets of data about posts, post users and post comments.  Data is downloaded as JSON, decoded and save it into 6 Core Data entities (post, post user, address, geo, company and comments).  
After it's saved it's loaded to a first viewcontroller where the post titles are shown on a tableview.  Theres a segmented control that present all posts or favorite posts.  if you swipe left a post row you can delete the post and it will delete automatically all the comments of the post deleted.  There is also a Delete all Core Data entities and Redownload 3 sets of data, save 6 entities to Core Data and load posts on a tableview button.  Posts not seen have a blue dot identifier on the left side of the row.  If the post is seen, the blue dot disappear, if the post is marked as favorite the blue dot is replace by a yellow star.  Initially posts are order by postId, but if there are favorites, favorites are order first and by postId, and then the rest of posts by postId.  if the tableview is segmented by Favorite, only favorites will be shown, ordered by postId (note: postId is the post identifier).
The second viewcontroller appears when a post is tapped, that post is marked as readed and saved in Core Data.  The second viewcontroller shows the body of the post and the some of the user information (name, email, phone, website) and and a tableview in the lower part of the screen that lists all the comments related to the selected post.  On the top right corner there is favorite star button, to set the post as favorite.  Initially the star button is white and if it's pressed it turns to yellow and save the post as favorite.


3.  Thid Party Libraries

No third party libraries were used.


4.  Requirements 

iO4 14.4 or higher.


5.  ToDo

Improvements can be made related to observers and optimization, as well as, the application of other technologies and frameworks.
