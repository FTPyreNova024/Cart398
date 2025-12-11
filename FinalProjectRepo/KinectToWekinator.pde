import oscP5.*;
import netP5.*;
import java.util.HashMap;

OscP5 oscP5;
NetAddress wekinator;

// Store ALL floats from ALL bodies in ONE buffer
FloatList allJointValues = new FloatList();

// Track whether ANY body has finished a frame
boolean frameReady = false;

void setup() {
  size(400, 200);
  oscP5 = new OscP5(this, 12345);          
  wekinator = new NetAddress("100.84.21.20", 6448);
  frameRate(60);

  println("Listening for multi-body Kinect OSC...");
}

void draw() {
  background(0);
  fill(255);
  text("Tracking ALL bodies, merging into one output", 20, 40);
  text("Total floats buffered: " + allJointValues.size(), 20, 70);

  if (frameReady) {
    fill(0, 255, 0);
    text("Frame ready → sending", 20, 110);
  }
}

void oscEvent(OscMessage msg) {
  String addr = msg.addrPattern();

  if (!addr.contains("/joints")) return;

  // Extract floats from message
  String types = msg.typetag();
  for (int i = 0; i < types.length(); i++) {
    if (types.charAt(i) == 'f') {
      allJointValues.append(msg.get(i).floatValue());
    }
  }

  // If THIS message contains FootRight for ANY body → end of frame
  if (addr.contains("FootRight")) {
    frameReady = true;
  }

  // If a frame is complete → send everything
  if (frameReady) {
    sendMergedToWekinator();
    allJointValues.clear();
    frameReady = false;
  }
}

void sendMergedToWekinator() {

  if (allJointValues.size() == 0) return;

  OscMessage out = new OscMessage("/wek/inputs");

  for (int i = 0; i < allJointValues.size(); i++) {
    out.add(allJointValues.get(i));
  }

  oscP5.send(out, wekinator);

  println("Sent merged frame with " + allJointValues.size() + " floats.");
}
