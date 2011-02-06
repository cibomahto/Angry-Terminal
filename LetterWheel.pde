// A collection of characters with a position, that represents the available inputs we can
// walk through.

class LetterWheel {
  private String letters;
  private int position;
  
  LetterWheel(String letters) {
    this.letters = letters;
    
    position = 0;
  }
  
  void next() {
    position++;
    if (position >= letters.length()) {
      position = 0;
    }
  }

  void previous() {
    position--;
    if (position < 0 ) {
      position = letters.length() - 1;
    }
  }
  
  char getLetter() {
    return letters.charAt(position);
  }
}
