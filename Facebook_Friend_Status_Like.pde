// Facebook Friend/Status/Like Search Using Temboo
// -----------------------------------------------
//
// Getting Facebook status data via Temboo is pretty easy,
// though parsing the data can be a bit tricky. This example
// does the following:
//
// - gets a list of your friends and creates array of IDs and names
// - gets all of your statuses
// - prints your statuses and who liked each one
// - gets statuses for each of your friends
// -prints out  their statuses and who liked each one
//
// That last part---printing out statuses for all your friends---is
// currently commted out. This is a because it's a *lot* of requests
// from Facebook (one for each of your friends), so only run
// this if you really want to. You can do all of your testing
// on yourself (or plug in a friend's ID to get theirs instead).
//
// If you want to parse different data from Facebook, you can 
// follow my examples and create your own version of 
// printStatusInfo(). Temboo’s page on JSON parsing may be helpful.
//
// Built Using Temboo and based off their examples
//
// by Ben Grosser
// http://bengrosser.com
//
// Originally written for ARTS 444: Computational Art at UIUC

import com.temboo.core.*;
import com.temboo.Library.Facebook.Reading.*;
 
// Create a session using your Temboo account application details
TembooSession session = new TembooSession("","","");
 
String accessToken = ""; // INSERT YOUR FACEBOOK TOKEN HERE
 
ArrayList friendNames;
ArrayList friendIDs;
 
void setup() {
 
  // grab (and print) your friend data from FB. fills 2 ArrayLists:
  // friendNames 
  // friendIDs
  getFriendIDs();
 
  // get your own statuses and names of who liked them
  getStatuses("me");
 
  // WARNING WARNING WARNING
  // This will grab data for EVERY friend! This can be a lot of data
  // you can just call getStatuses("00010202309202") for whichever friend you 
  // want data from instead of getting data from all of them
   
//  run through all of your friends and get their statuses and who liked them
//  for(int i = 0; i < friendIDs.size(); i++) {
//    String friendID = friendIDs.get(i).toString();
//    String friendName = friendNames.get(i).toString();
//    println("\n---------------------------------------------");
//    println("STATUSES FOR: "+friendName);
//    getStatuses(friendID);
//  }
   
}
 
// gets all your friends and returns an array with their IDs
void getFriendIDs() {
  Friends friendsConnector = new Friends(session);
  friendsConnector.setAccessToken(accessToken);
  FriendsResultSet friendsResults = friendsConnector.run();
  //println(friendsResults.getResponse());
  JSONObject response = parseJSONObject(friendsResults.getResponse());
  JSONArray data = response.getJSONArray("data");
   
  friendIDs = new ArrayList();
  friendNames = new ArrayList();
   
  for(int i = 0; i < data.size(); i++) {
    JSONObject friend = data.getJSONObject(i);
    String name = friend.getString("name");
    String id = friend.getString("id");
     
    friendIDs.add(id);
    friendNames.add(name);
     
    //println(name + " : " + id);
  }
}
 
void getStatuses(String profileID) {
  // Create the Choreo object using your Temboo session
  Statuses statusesChoreo = new Statuses(session);
 
  // Set inputs
  statusesChoreo.setAccessToken(accessToken);
   
  if(profileID != "me") {
    statusesChoreo.setProfileID(profileID);
  }
   
  // Run the Choreo and store the results
  StatusesResultSet statusesResults = statusesChoreo.run();
 
  // want to see what you're getting? print out statusesResults.getResponse(), 
  // copy output, and then paste into a JSON beautifer, like http://jsonformatter.curiousconcept.com/
  // println(statusesResults.getResponse());
   
  // extract and printout status info  
  printStatusInfo(statusesResults);
 
}
 
// looks at a statusResult and extracts some info
// needs to be customized to meet your needs if they're different than this 
// https://temboo.com/processing/parsing-json can be helpful trying to figure it out
void printStatusInfo(StatusesResultSet s) {
   
  // create a JSONObject from the StatusesResultSet
  JSONObject response = parseJSONObject(s.getResponse());  
 
  // 'data' holds all of our response data  
  JSONArray data = response.getJSONArray("data");
   
  // print raw data
  //println(data);
     
  // run through the objects in data (our statuses)
  for(int i = 0; i < data.size(); i++) {
     
    // extract a status from the data
    JSONObject status = data.getJSONObject(i);
     
    // see if there's a message (sometimes there's not)
    // extract the message string if there is one
    String message;
        
    try {
      message = status.getString("message");
    } catch (Exception e) {
      message = null;
    }
     
    // if we don't have one, skip to the next for() iteration
    if(message == null) continue;
     
    // print the message string (e.g. the status)
    println("\n\n"+message);
     
    // check for and get all the likers of this status
    // if there are any
    JSONObject likes;
     
    // see if there are any likes (there may not be)
    // use try/catch as if there aren't any it throws 
    // an error --- this lets us get by it if there is
    try {
      likes = status.getJSONObject("likes");
    } catch (Exception e) {
      likes = null;
    }
 
    // if there are some likes, process them
    if(likes != null) {
       
      // get an array of all the likers
      JSONArray likers = likes.getJSONArray("data");
       
      // we have some, so printout a header
      println("  Liked by:");
       
      // run through all of the likes, extract/print name
      for(int j = 0; j < likers.size(); j++) {
        String liker = likers.getJSONObject(j).getString("name");
        println("   -"+liker);
      }
       
    } // end like process
     
  } // end of status for()
   
}
