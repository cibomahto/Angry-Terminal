// State machine for combining keypresses that happen close together. The idea is that if
// we get multiple presses in a short time, than we want to evaluate them as a single event.

class KeyQueue {
  private String keyQueue = new String();
  private float lastTime;
  
  private float maxDelta = 40;
  

  void evaluate() {
    if( (keyQueue.length() > 0) && (millis() - lastTime > maxDelta) ) {
      keyQueueExpired(keyQueue);
      keyQueue = "";
    }
  }
  
  void addKey(char key) {
    keyQueue = keyQueue + key;
    lastTime = millis();
  }
}

