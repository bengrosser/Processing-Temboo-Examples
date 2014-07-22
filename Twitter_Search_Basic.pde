// Twitter Search Basic Using Temboo
// --------------------------------
//
// The most basic Twitter search example. Searches for a string
// on Twitter, returns a set of results. Repeated searches may
// contain previously returned results.
//
// Built Using Temboo
// Based off of Temboo Examples at:
//   https://temboo.com/processing/display-tweet
//   https://temboo.com/library/Library/Twitter/Search/Tweets/
//
// by Ben Grosser
// http://bengrosser.com
//
// Originally written for ARTS 444: Computational Art at UIUC

 
import com.temboo.core.*;
import com.temboo.Library.Twitter.Search.*;
 
// Create a session using your Temboo account application details
TembooSession session = new TembooSession("","","");
 
Tweets twitterSearch;
TweetsResultSet tweetsResults;
 
// WARNING: NEVER POST THESE TO THE BLOG -- ERASE BEFORE POSTING
// Twitter Credentials (get these by creating a new app here: https://dev.twitter.com/apps/new)
// you'll need to also generate an access token on the API keys page
String accessToken = "";
String accessTokenSecret = "";
String APIkey = "";
String APISecret = "";
 
void setup() {
  // Run the Tweets Choreo function
  setupTwitterSearch();
  searchTweets("demetricator");
}
 
void searchTweets(String query) {
  twitterSearch.setQuery(query);
  tweetsResults = twitterSearch.run();
   
  // print out the tweets
  printTweetsResults(tweetsResults.getResponse());
   
  // how many twitter searches do you have remaining today?
  println("You have "+tweetsResults.getRemaining()+" searches remaining today.");
}
 
void printTweetsResults(String r) {
  JSONObject searchResults = parseJSONObject(r);
  JSONArray statuses = searchResults.getJSONArray("statuses"); // Create a JSON array of the Twitter statuses in the object
   
  JSONObject tweets;
   
  try {
    tweets = statuses.getJSONObject(0); // Grab the first tweet and put it in a JSON object
  } catch (Exception e) {
    tweets = null;
  }
  
  if(tweets == null) println("No results.");
  else { 
    for(int i = 0; i < statuses.size(); i++) {
      String tweetText = statuses.getJSONObject(i).getString("text");
      println(tweetText+"\n");
    }
  }
}
 
void setupTwitterSearch() {
  // Create the Choreo object using your Temboo session
  twitterSearch = new Tweets(session);
 
  // Set inputs
  twitterSearch.setAccessToken(accessToken);
  twitterSearch.setAccessTokenSecret(accessTokenSecret);
  twitterSearch.setConsumerSecret(APISecret);
  twitterSearch.setConsumerKey(APIkey);
}
