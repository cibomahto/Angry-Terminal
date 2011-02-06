// Represents a group of keys whose inputs are combined together to produce a single key.
// If you are using this, don't use the keyPressed() or keyReleased() functions in your sketch.

void keyPressed() {
  if (keyGroups == null) {
    return;
  }
  
  for (int i = keyGroups.size()-1; i >= 0; i--) { 
    KeyGroup keygroup = (KeyGroup) keyGroups.get(i);
    keygroup.reportKeyPressed(key);
  }
}

void keyReleased() {
  if (keyGroups == null) {
    return;
  }
  
  for (int i = keyGroups.size()-1; i >= 0; i--) { 
    KeyGroup keygroup = (KeyGroup) keyGroups.get(i);
    keygroup.reportKeyReleased(key);
  }  
}

/*
void keyPressed(KeyEvent e) {
  print("here!"); 
}
*/

static ArrayList keyGroups;

class KeyGroup {
  private String keysToMonitor;
  private boolean[] keyStates;
  private char name;
  private boolean pressed;
  
  
  public KeyGroup(char name, String keysToMonitor) {
    this.name = name;
    this.keysToMonitor = keysToMonitor;
    this.keyStates = new boolean[keysToMonitor.length()];
    this.pressed = false;
    
    // Now, add ourself to the list of key groups
    if (keyGroups == null) {
      // If this is the first group, we need to create a list
      keyGroups = new ArrayList();
    }
    
    keyGroups.add(this);
  }
  
  
  public void reportKeyPressed(char key) {
    for(int i = 0; i < keysToMonitor.length(); i++) {
      // Check if we are monitoring this key
      if (keysToMonitor.charAt(i) == key) {
        keyStates[i] = true;
       
        // If we aren't pressed already, mark us as pressed and emit a signal
        if (!pressed) {
          pressed = true;
          keyGroupPressed(name);
        }
      }
    }
  }
  
  public void reportKeyReleased(char keyf) {
    for(int i = 0; i < keysToMonitor.length(); i++) {
      
      // Check if we are monitoring this key
      if (keysToMonitor.charAt(i) == key) {
        keyStates[i] = false;
       
        // If we are pressed, check to see if we should be released
        if (pressed) {
          for (int j = 0; j < keysToMonitor.length(); j++) {
            if (keyStates[j] != false) {
              return;
            }
          }
          
          pressed = false;
          keyGroupReleased(name);
        }
      }
    }
  }
}
