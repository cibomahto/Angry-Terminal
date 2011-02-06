
class TextField {
  private ArrayList lines;
  private PFont characterFont;
  private int characterSize;
  private color characterColor;
  private int posX;
  private int posY;
  private int widthX;
  private int widthY;

  private float lineHeight;

  TextField(int posX, int posY, int widthX, int widthY, PFont font, int size, color col) {
    this.posX = posX;
    this.posY = posY;
    this.widthX = widthX;
    this.widthY = widthY;

    lines = new ArrayList();
    lines.add(new String());

    characterFont = font;
    characterSize = size;
    characterColor = col;

    // TODO: actually calculate this
    textFont( characterFont, characterSize );
    lineHeight = textAscent()*1.05;
  }

  private void addLine() {
    lines.add(new String());

    if((lines.size() + 2) * lineHeight > widthY) {
      lines.remove(0);
    }
  }

  void add(String text) {
    for(int i = 0; i < text.length(); i++) {
      addCharacter(text.charAt(i));
    }
  }

  void addCharacter(char text) {
    if(text == '\n' || text == '\r') {
      addLine();
    }
    else {
      // if the character won't fit in the current line, insert a new line first.
      textFont( characterFont, characterSize );
      if ( textWidth((String)lines.get(lines.size()-1) + text) > widthX ) {
        addLine();        
      }

      String lastLine = (String)lines.get(lines.size()-1);
      lastLine = lastLine + text;
      lines.set(lines.size()-1, lastLine);
    }


  }

  void draw() {
    fill(characterColor);
    textFont( characterFont, characterSize );

    for(int i = 0; i < lines.size(); i++) {
      text((String) lines.get(i), posX, posY + lineHeight*(i+1));
    }
  }
  
  int[] getCursorPos() {
    int position[] = new int[2];

    textFont( characterFont, characterSize );
    // X position
    position[0] = (int)textWidth((String)lines.get(lines.size()-1));
    
    // Y position
    position[1] = (int)(lineHeight*(lines.size()));
    
    return position;
  }
  
  String getLine() {
    return (String)lines.get(lines.size()-1);
  }  
}




