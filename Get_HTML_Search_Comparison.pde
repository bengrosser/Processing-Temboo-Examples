// HTML Search Term Comparison using Temboo
// ----------------------------------------
//
// This quick example uses Temboo's Get() to grab HTML from two 
// different sites, searches that HTML for specified terms,  
// counts and then prints out the results. 
// Requires Temboo credentials.
//
// by Ben Grosser
// http://bengrosser.com

 
import com.temboo.core.*;
import com.temboo.Library.Utilities.HTTP.*;
 
// Create a session using your Temboo account application details
TembooSession session = new TembooSession("","","");
 
void setup() {
  getData("http://nytimes.com");
  getData("http://cnn.com");
}
 
void getData(String url) {
  // Create the get object using your Temboo session
  Get get = new Get(session);
 
  // Set input based on incoming URL
  get.setURL(url);
 
  // Run the Choreo and store the results
  GetResultSet getResults = get.run();
 
  String html = getResults.getResponse();
  
  int theCount = getMatchCount("The ",html) + getMatchCount("the ",html);
  int itCount = getMatchCount("it ",html) + getMatchCount("It ",html);
  
  println("\n"+url);
  println("-----------------");
  println("The: "+theCount); 
  println("It: "+itCount);
}
 
// a simple function to find how many times string 'find'
// occurs in string 's'.  copy and use!
int getMatchCount(String find, String s) {
  int m = s.split(find).length;
  return m - 1;
}
