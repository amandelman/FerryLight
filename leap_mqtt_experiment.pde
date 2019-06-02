//importa leap motion and mqtt libraries
import de.voidplus.leapmotion.*;
import mqtt.*;

//instatiate leap and mqtt client classes
LeapMotion leap;
MQTTClient client;

void setup() {
  //initialize mqtt client, address, publishing channel, subscription channel
  client = new MQTTClient(this);
  client.connect("mqtt://try:try@broker.shiftr.io", "leap-experiment1");
  client.subscribe("/leap-experiment2");
  //create canvas
  size(700, 1200);
  background(255);
  // ...
  
  //initialize leap motion
  leap = new LeapMotion(this);
}

void draw() {
  background(255);
  
  //get hand data
  //int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    //declare booleans for left and right hand detection
    boolean handIsLeft = hand.isLeft();
    boolean handIsRight = hand.isRight();
    
    //draw an ellipse with x,y position and width based on LEFT hand x,y,z
    if(handIsLeft){
      PVector handPosition = hand.getPosition();
      //draw an ellipse and send the data to MQTT broker
      //fill(255,0,0);
      //noStroke();
      //ellipse(handPosition.x, handPosition.y*0.75, handPosition.z*10, 100);
      //publish LEFT hand x,y,z position to mqtt channel
      //client.publish("/leap-experiment1", "ld-left "+handPosition.x+" "+handPosition.y+" "+handPosition.z);
      
      //Attempted to send hand data to mqtt broker so that subscriber would draw remote hands BUT that didn't work because the variable hand contains a fuckton of data
      Hand hand2 = hand;
      client.publish("/leap-experiment1", "ld-myhand "+hand2);
      println(hand2);
      }
    
    //draw an ellipse with x,y position and width based on RIGHT hand x,y,z
    if(handIsRight){
      PVector handPosition = hand.getPosition();
      //fill(0,0,255);
      //noStroke();
      //ellipse(handPosition.x+150, handPosition.y*0.75, handPosition.z*10, 100);
      //publish RIGHT hand x,y,z position to mqtt channel
      client.publish("/leap-experiment1", "ld-right "+handPosition.x+" "+handPosition.y+" "+handPosition.z);
      }
   
   hand.draw();
   }
}


//receive left and right hand position data from MQTT
//NEXT STEPS: translate data into drawing commands
void messageReceived(String topic, byte[] payload) {
  String msg = new String(payload);
  println("new message: " + topic + " - " + msg);
  if(msg.indexOf("ld-left")==0){
    String[] params = split(msg, " ");
    if (params.length==4){
      int x = parseInt(params[1]);
      int y = parseInt(params[2]);
      int z = parseInt(params[3]);
      println(x, y);
      noStroke();
      fill(0, 255, 0);
      ellipse(x, y*0.75, z, 10);
    }
  }
   if(msg.indexOf("ld-right")==0){
    String[] params = split(msg, " ");
    if (params.length==4){
      int x = parseInt(params[1]);
      int y = parseInt(params[2]);
      int z = parseInt(params[3]);
      println(x, y);
      noStroke();
      fill(0, 0, 0);
      ellipse(x, y*0.75, z, 10);
    }
  }
}
