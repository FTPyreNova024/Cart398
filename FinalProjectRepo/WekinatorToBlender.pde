import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

float[] values = new float[15];

void setup() {
  size(400, 200);
  
  // Port to RECEIVE from Wekinator
  oscP5 = new OscP5(this, 12000);
  
  // Port to SEND to your next app (Blender / etc)
  dest = new NetAddress("100.84.21.20", 7000);

  println("Listening for /wek/outputs …");
}

void oscEvent(OscMessage msg) {
  
  if (msg.checkAddrPattern("/wek/outputs") && msg.typetag().length() >= 15) {

    // Store original values
    for (int i = 0; i < 15; i++) {
      values[i] = msg.get(i).floatValue();
    }

    // Convert 14,13,12: 0–1 → 0–360
    values[13] = map(values[13], 0, 1, -6.28, 6.28);
    values[12] = map(values[12], 0, 1, -6.28, 6.28);
    values[11] = map(values[11], 0, 1, -6.28, 6.28);

    // Convert 11,10,9: 0–1 → -1 to 1
    values[10] = map(values[10], 0, 1, -2, 2);
    values[9] = map(values[9], 0, 1, -2, 2);
    values[8]  = map(values[8],  0, 1, -2, 2);

    // Create new OSC message
    OscMessage updated = new OscMessage("/wek/updated");

    for (int i = 0; i < 15; i++) {
      updated.add(values[i]);
    }

    oscP5.send(updated, dest);

    println("Updated values sent → /wek/updated");
    
    println(updated);
  }
}
