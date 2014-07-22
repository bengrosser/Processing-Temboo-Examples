// Twitter Search Demo Using Temboo
// --------------------------------
//
// Periodically searches for a specific string on Twitter using 
// the Temboo library, and only returns NEW hits since the last
// search. 
//
// Uses setSinceId() to ensure new searches don't return old results
// Also illustrates parsing JSON results from Twitter
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
 
// lastID will keep track of the last tweet ID we saw 
// start at 0 to ensure we just get the most recent 100 tweets
// for our search string
String lastID = "0";
 
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
  
  // testing running the same search but only looking for what's new
  // using setSinceId() (see code in getTweetsResults() and 
  ArrayList test = getTweetsResults("movies");
  println("size of test = "+test.size());
 
  // run it again. should report less hits  
  test = getTweetsResults("movies");
  println("size of test = "+test.size());
 
  // try one more time. should be less or the same (my test string "movies"
  // gets tweeted regularly, but it definitely shouldn't jump back up to 100
  test = getTweetsResults("movies");
  println("size of test = "+test.size());  
   
  reportSearchesRemaining();  
}
 
 
 
ArrayList getTweetsResults(String q) {
  twitterSearch.setQuery(q);
  twitterSearch.setCount("200");
   
  // setSinceId says to only get tweets SINCE lastID
  twitterSearch.setSinceId(lastID);
   
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
    // grab the lastID of the last tweet processed (in reverse order,
    // so we want index 0). this gets used on the NEXT search to ensure
    // we don't get tweets we've already seen
    lastID = statuses.getJSONObject(0).getString("id_str");
     
    for(int i = 0; i < statuses.size(); i++) {
      String tweetText = statuses.getJSONObject(i).getString("text");
      //println(tweetText+"\n");
      results.add(tweetText);
    }
  }
  return results;
}  
 
void reportSearchesRemaining() {
  println("You have "+tweetsResults.getRemaining()+" searches remaining today.");
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
