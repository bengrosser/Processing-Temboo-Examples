// Twitter Search Results as ArrayList
// -----------------------------------
//
// Illustrates how to search Twitter using Temboo. Results 
// are returned in an ArrayList, making it easy to track, store,
// and compare different search queries for later processing. 
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
  
  // setup ArrayList variables to hold results, and run searches 
  ArrayList lovemyself = getTweetsResults("\"love myself\"");
  ArrayList justlove = getTweetsResults("love");
   
  // print out results 
  println("\nLOVE MYSELF");
  println("-----------");
  for(int i = 0; i < lovemyself.size(); i++) {
    println(lovemyself.get(i));
  }
   
  println("\nJUST LOVE");
  println("---------");
  for(int i = 0; i < justlove.size(); i++) {
    println(justlove.get(i));
  }  
   
}
 
void searchTweets(String query) {
  twitterSearch.setQuery(query);
  tweetsResults = twitterSearch.run();
   
  // print out the tweets
  printTweetsResults(tweetsResults.getResponse());
   
  // getResponse() gives you JSON data with the tweets
  // pretty print the output using jsonprettyprint.com
  // if you want to see what the output looks like
  // println(tweetsResults.getResponse());
   
  // how many twitter searches do you have remaining today?
  println("You have "+tweetsResults.getRemaining()+" searches remaining today.");
}
 
ArrayList getTweetsResults(String q) {
  twitterSearch.setQuery(q);
  twitterSearch.setCount("200");
  tweetsResults = twitterSearch.run();
  JSONObject searchResults = parseJSONObject(tweetsResults.getResponse());
  JSONArray statuses = searchResults.getJSONArray("statuses"); // Create a JSON array of the Twitter statuses in the object
   
  JSONObject tweets;
   
  try {
    tweets = statuses.getJSONObject(0); // Grab the first tweet and put it in a JSON object
  } catch (Exception e) {
    tweets = null;
  }
  
  ArrayList results = new ArrayList();
   
  if(tweets != null) {
   
    for(int i = 0; i < statuses.size(); i++) {
      String tweetText = statuses.getJSONObject(i).getString("text");
      //println(tweetText+"\n");
      results.add(tweetText);
    }
  }
  return results;
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
