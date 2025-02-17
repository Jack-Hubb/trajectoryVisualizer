static public class Keyboard {

  private static boolean[] keys = new boolean[193];
  private static boolean[] pKeys = new boolean[193];

  public static final int ONE = 49;
  public static final int TWO = 50;
  public static final int THREE = 51;
 public static final int  SPACE = ' ';


  public static void update() {


    for (int i = 0; i < keys.length; i++) {
      pKeys[i] = keys[i];
    }
  }


  private static void handleKey(int code, boolean isDown) {
    keys[code] = isDown;                                                                   
  }                                                                                         


  public static void handleKeyUp(int code) {
    handleKey(code, false);
  }

  public static void handleKeyDown(int code) {
    handleKey(code, true);
  }

  public static boolean isDown(int code) {
    return keys[code];
  }


  public static boolean onDown(int code) {
    return (keys[code] && !pKeys[code]);
  }
}

static public class Mouse {

  private static boolean[] buttons = new boolean[3];
  private static boolean[] pButtons = new boolean[3];

  public static final int LEFT = 0;

  public static void update() {
    for (int i = 0; i < buttons.length; i++) {
      pButtons[i] = buttons[i];
    }
  }


  private static void handleKey(int code, boolean isDown) {
    buttons[code] = isDown;                                                                  
  }                                                                              
  public static void handleKeyUp(int code) {
    handleKey(code, false);
  }

  public static void handleKeyDown(int code) {
    handleKey(code, true);
  }

  public static boolean isDown(int code) {
    return buttons[code];
  }



  public static boolean onDown(int code) {
    return (buttons[code] && !pButtons[code]);
  }
}
