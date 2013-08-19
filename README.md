TweetGrabber
============

TweetGrabber is a set of Ruby scripts for pulling in the tweets of people and hashtags you want to follow.


Requirements
============

Main
----

* Ruby >= 1.9.2
* Rails 3 >= 3.1 or Rails 4
* [MongoDB](http://www.mongodb.org/downloads) >= 2.4.3

Ruby Gems
---------
* logger >= 1.2.8
* tweetstream  >= 2.5.0 
* smarter_csv >= 1.0.10
* mongo >= 1.9.1


Installation
============

Assuming that you have a [MongoDB replication set](http://docs.mongodb.org/manual/replication/) up and running, have created a database and a collection, and also have Ruby and Rails installed...

1. Create [a Twitter application(https://dev.twitter.com/) to use for your TweetGrabber
2. Create an oAuth token in your Twitter application, and save all of the credentials
3. Download the TweetGrabber source and unpack into a directory
4. Open lib/tweetgrabber.rb, and update the configuration variables in the "Config Variables" section
5. Create a CSV file to hold the Twitter information for the people you want to follow. There's an example file you can use in the root folder. If you need to get a Twitter ID for a user account, I suggest using [mytwitterid.com](http://mytwitterid.com/).
6. Install the required gems via Bundler (bundle install)
7. At the command line, run the following command:

    ruby lib/tweet_grabber.rb

8. Enjoy the tweets!


To Follow Keyword Terms
-----------------------

Do all of the above, but instead of creating a CSV file of users, add a list of terms to the keywords_to_track array in the lib/hashtag_grabber.rb file.


Notes
=====

1. When using the hashtag_grabber.rb script, I've found it unnecessary to use the '#' part of a hashtag in order to actually follow that hashtag.


Need Help?
==========

TweetGrabber was written by me, Robert Dempsey. As such, I'm happy to help you out if you need it. Please [file an issue](https://github.com/rdempsey/tweetgrabber/issues) if something isn't working for you.

You can also contact me tons of other ways:

* [Twitter](https://twitter.com/rdempsey)
* [LinkedIn](http://www.linkedin.com/in/robertwdempsey)
* [Google+](http://robertwdempsey.com/plus)
* [My personal blog](http://robertwdempsey.com/)
* Work email: robert.dempsey@intridea.com
* Work phone: 1-888-968-4332 x517


Want To Contribute?
===================

Awesome. Please fork the project and send me a pull request!


License
=======

TweetGrabber is licensed under the MIT License (MIT). Read about [what that means to you](http://choosealicense.com/licenses/mit/), or read the LICENSE file.