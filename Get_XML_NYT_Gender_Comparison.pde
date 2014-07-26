// NYTimes Obit Gender Comparator Using Temboo Get()
// -------------------------------------------------
//
// This example visualizes the use of gendered titles 
// (e.g. Mr. vs Ms.) on the NY Times’ Obituary Page. You’ll need 
// to get your own Temboo credentials and plug them into the 
// TembooSession() call to make this work. The Temboo technique
// being used here is their Get() function, which I use to grab
// the XML-based RSS data. I then parse it to extract the numbers
// I need for the comparison.
// 
// Built Using the Temboo library and service from:
//   https://www.temboo.com/processing
//   for basics of XML processing, roughly drawing on example 
//   from https://www.temboo.com/processing/parsing-xml 
//
// Inspired by a gender comparison app from Kelly Delahanty
//
// by Ben Grosser
// http://bengrosser.com
//
// Originally written for ARTS 444: Computational Art at UIUC

// import Temboo library
import com.temboo.core.*;
import com.temboo.Library.Utilities.HTTP.*;
 
// vars for our Temboo session
TembooSession session;
Get get;
GetResultSet results;
 
// a var to hold our XML/RSS
XML xml;
 
// is the requested data ready yet?
boolean gotnew = false;
 
// timer interval and vars
float interval = 7500; // our timer interval in milliseconds
float startTime = 0;
float lineX = 0;
float jump;
float fps = 10;
 
// starting size for gender elements
int msize = 10;
int wsize = 10;
 
// how many Men vs Women are on the Obit page?
int mencount = 0;
int womencount = 0;
 
void setup() {
  size(500,500);
  rectMode(CORNER);
  frameRate(fps);
 
  // setup our jump so that we roughly scan the width every interval
  jump = width/(fps*(interval/1000));
   
  // init our Temboo session (USE YOUR CREDENTIALS)
  session = new TembooSession("","","");
   
  // setup a variable to get dat`a from a URL
  get = new Get(session);
   
  // set the URL we'll get RSS data from
  get.setURL("http://www.nytimes.com/services/xml/rss/nyt/Obituaries.xml");
  thread("getData"); 
}
 
void draw() {
   
  // make our line fade
  fill(60,50);
  noStroke();
  rectMode(CORNER);
  rect(0,0,width,height);
   
  // get current time since we started
  float now = millis();
   
  // if our current time has passed our interval + our last startTime
  // we've arrived at our interval!
  if(now > startTime + interval) {
    startTime = now;
    thread("getData");
    println(interval/1000+" seconds");
  }
   
    // if we have new data, reset sizes
  if(gotnew) {
    gotnew = false;
 
    // reset our element size whenever we have new data to show
    msize = 10;
    wsize = 10;
  }
 
  // draw our representations (if appropriate)
  drawMen();
  drawWomen();
 
  // draw a horizontal line to visualize our timer  
  stroke(128,60);
  strokeWeight(2);
  line(lineX,0,lineX,height);
   
  // calc position for next timer line, reset to 0 if we go over edge
  lineX += jump;
  if(lineX >= width) lineX = 0; 
}
 
// get some data!
void getData() {
   
  // ask for XML data from the RSS feed!
  results = get.run();
   
  // parse out the XML
  xml = parseXML(results.getResponse());
   
  // verify we got it, if so, inspect it
  if(xml == null) {
    println("XML parse error");
  } else {
     
    // suck all <item> tags from the XML and put in array items
    XML[] items = xml.getChildren("channel/item");
     
    // run through all items in the array
    for (int i = 0; i < items.length; i++) {
       
      // extract the title, link, and desc
      String title = items[i].getChild("title").getContent();
      String link = items[i].getChild("link").getContent();
      String desc = items[i].getChild("description").getContent();
       
      // check for men
      if(title.contains("Mr.") || title.contains("He") ) mencount++;
      if(desc.contains("Mr.") || desc.contains("He") ) mencount++;
       
      // check for women
      if(title.contains("Miss") || title.contains("Ms.") || title.contains("Mrs.") || title.contains("Her") ) womencount++;
      if(desc.contains("Miss") || desc.contains("Ms.") || desc.contains("Mrs.") || desc.contains("Her") ) womencount++;  
  }
     
    // we have new data, so let draw() know
    gotnew = true;
     
    println("Men: "+mencount);
    println("Women: "+womencount);
         
  }
}
 
// draw circles based on the # of men found
void drawMen() {
  if(mencount > 0) {
    rectMode(CENTER);
    noFill();
    stroke(135,206,231);
    ellipse(width/4,height/2,msize,msize);
     
    msize+=10;
    mencount--;
  }
}
 
// draw rects based on the # of women found
void drawWomen() {
  if(womencount > 0) {
    rectMode(CENTER);
    noFill();
    stroke(200,150,150);
    ellipse(width/4+width/2,height/2,wsize,wsize);
 
    wsize+=10;
    womencount--;
  }
}
