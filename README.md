# BirbNoise
 Twitter clone
# Project 2 - *Birb Noise*

**Birb Noise** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **21** hours spent in total

## User Stories

The following **core** features are completed:

**A user should**

- [X] See an app icon in the home screen and a styled launch screen
- [X] Be able to log in using their Twitter account
- [X] See at latest the latest 20 tweets for a Twitter account in a Table View
- [X] Be able to refresh data by pulling down on the Table View
- [X] Be able to like and retweet from their Timeline view
- [X] Only be able to access content if logged in
- [X] Each tweet should display user profile picture, username, screen name, tweet text, timestamp, as well as buttons and labels for favorite, reply, and retweet counts.
- [X] Compose and post a tweet from a Compose Tweet view, launched from a Compose button on the Nav bar.
- [X] See Tweet details in a Details view
- [X] App should render consistently all views and subviews in recent iPhone models and all orientations

The following **stretch** features are implemented:

**A user could**

- [X] Be able to **unlike** or **un-retweet** by tapping a liked or retweeted Tweet button, respectively. (Doing so will decrement the count for each)
- [X] Click on links that appear in Tweets
- [X] See embedded media in Tweets that contain images or videos
- [X] Reply to any Tweet (**2 points**)
  - Replies should be prefixed with the username
  - The `reply_id` should be set when posting the tweet
- [X] See a character count when composing a Tweet (as well as a warning) (280 characters) (**1 point**)
- [X] Load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client
- [X] Click on a Profile image to reveal another user's profile page, including:
  - Header view: picture and tagline
  - Basic stats: #tweets, #following, #followers
- [ ] Switch between **timeline**, **mentions**, or **profile view** through a tab bar (**3 points**) (I didnt want to do this one I added my own features)
- [ ] Profile Page: pulling down the profile page should blur and resize the header image. (**4 points**) (same with this one)

The following **additional** features are implemented:

- [X] Somewhat infinite scrolling
- [X] See the time since posting a tweet.
- [X] Able to see other users replies, tweets and likes.
- [X] Able to see whether a user is verified or not
- [X] Able to logout on profile screen.
- [X] Progress bar indicating how much of your character count you have typed.
- [X] Replies automatically include a mention in them.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to implement replies on tweets.
2. How to implement UI Scroll Views

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://imgur.com/QUBeeew' title='Video Walkthrough' width='' alt='Video Walkthrough' />

![Kapture 2022-06-24 at 16 15 36](https://user-images.githubusercontent.com/48461874/175738443-d014c60d-32ce-4b5f-96d7-27f7777e9503.gif)

GIF created with [Kap](https://getkap.co/).

## Notes

Describe any challenges encountered while building the app.
I struggled with many things while building this app. Including images was very difficult and it took a long time to find a way to include images. Originally I had an image view that I was trying to collapse when there was no media but this didnt work. In the end, I ended up finding a way to put images in a text field and I figured out how to format those text fields. There were a lot of segues that were annoying to configure. Autolayout was also frustrating to deal with. The easiest part of teh app was probably making the backend and API calls since the Twitter API was very straight forward. Other things that I struggled with were trying to figure out better ways to implement hyperlinks, which I ended up just sticking with the original anyways and formatting.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
