# Project 4: Facebook

The purpose of this homework is to leverage animations and gestures to transition between screens. We're going to use the techniques from this week to implement some interactions in Facebook.

Time Spent: 15 hours

Completed User Stories:
* [x]	Tapping on a photo in the news feed should expand the photo full screen.
* [x]	Tapping the Done button should animate the photo back into its position in the news feed.
* [x]	On scroll of the full screen photo, the background should start to become transparent, revealing the feed.
* [x]	If the user scrolls a large amount and releases, the full screen photo should dismiss.
* [x]	Optional: The full screen photo should be zoomable.
* [x]	Optional: The user should be able to page through the other photos in full screen mode.

Notes:

Spent an hour just catching up the project to the in class assignment like the instructions said, then realized that wasn't necessary (directions should really be clearer).
Spent 4 hours on the bulk of the work (everything but paging).
I lost track of how much time I spent getting paging & zooming to play nice with eachother, so I'm going to ballpark that alone at 10 hours although it was probably more. I blame bad instructions on the assignment milestone claiming that we can use one UIScrollView for both paging and zooming. Doing this seems to result in the all the images unexpectedly moving across the screen in an unpredictable mannor. Finally found a better explanation on a WWDC talk:
https://developer.apple.com/videos/wwdc/2010/?id=104

Walkthrough of all user stories:

![Video Walkthrough](demo2.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
