KeyGroup leftKey;
KeyGroup rightKey;
LetterWheel selector;
KeyQueue keyQueue;
TextField textField;

ProcessLauncher shell;

PFont cursorFont;
int cursorSize;
color cursorColor;

void setup() {
  size(1024, 768);

  cursorFont = loadFont("Monospaced.plain-40.vlw");
  cursorSize = 30;
  cursorColor = color(0,230,0);

  textField = new TextField(0,0,width,height, cursorFont, cursorSize, cursorColor);
  selector = new LetterWheel("abcdefghijklmnopqrstuvwxxy1234567890\\/,.*~! ");

  keyQueue = new KeyQueue();

  // We want to have two virtal keys, l for left and r for right
  leftKey = new KeyGroup('l', "123456qwertyasdfgzxcvb");
  rightKey = new KeyGroup('r', "7890-=uiop[]\\hjkl;\'nm,./");

  // Change this to whatever command line program you want to punch
  shell = new ProcessLauncher("bash");

  print(textField.widthX);
}

String previousKeys = "";

// Whenever we get a bunch of keys
void keyQueueExpired(String keys) {
  if (keys.equals("rl")) {
    keys = "lr";
  }

  if ((keys.equals("l") && previousKeys.equals("r"))
    || (keys.equals("r") && previousKeys.equals("l"))) {
    selector.next();
  }
  else if (keys.equals("lr") && previousKeys.equals("lr")) {
    shell.write(textField.getLine() + '\n');
    textField.addCharacter('\n');
  }
  else if (keys.equals("lr")) {
    textField.addCharacter(selector.getLetter());
  }

  previousKeys = keys;
}

void keyGroupPressed(char key) {
  // First, see if our key queue expired already
  keyQueue.evaluate();

  // Now, add the new key.
  keyQueue.addKey(key);
}


void keyGroupReleased(char key) {
}

void draw() {
  // Hit the keyQueue, to see if any new events have come in from the keyboard
  keyQueue.evaluate();

  // Check if there is any new data from our shell process that we should display
  while (shell.hasData()) {
    textField.add(shell.read());
    textField.addCharacter('\n');
  }

  // Finally, redraw the screen.
  background(0);
  textField.draw();

  // Blinking cursor!
  fill(cursorColor);
  textFont( cursorFont, cursorSize );

  int cursorPos[] = textField.getCursorPos();
    text(selector.getLetter(), cursorPos[0], cursorPos[1]);
}


