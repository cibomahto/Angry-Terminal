import java.util.concurrent.*;

// Thread code from here:
// http://stackoverflow.com/questions/3343066/reading-streams-from-java-runtime-exec

class ProcessLauncher {

  private Process shell;

  private java.io.BufferedReader stdOut;
  private java.io.BufferedReader stdErr;
  private java.io.BufferedWriter stdIn;

  // Queue of strings that are going to and from the process
  private LinkedBlockingQueue inputQueue = new LinkedBlockingQueue();
  private LinkedBlockingQueue outputQueue = new LinkedBlockingQueue();
    

  ProcessLauncher(String interpreter) {

    // Open the shell
    try{
      shell = Runtime.getRuntime().exec(interpreter);
    }
    catch(Exception e){
      println(e);
    }

    // Make input and output stream readers that are connected to the process    
    stdOut = new java.io.BufferedReader( new java.io.InputStreamReader(shell.getInputStream()));
    stdErr = new java.io.BufferedReader( new java.io.InputStreamReader(shell.getErrorStream()));
    stdIn = new java.io.BufferedWriter( new java.io.OutputStreamWriter(shell.getOutputStream()));

    // launch a thread to read data from the process
    new Thread() {
      public void run() {
        while(true) {
//          print("out:");
          try {
            if (stdOut.ready()) {
              String line;

              while ((line = stdOut.readLine()) != null) {
                try{
                  outputQueue.put(line);
                }
                catch( InterruptedException e ) {
                  println("Interrupted Exception caught");
                }
                
                print(line + '\n');
                //                     out.write(line + "\n");
              }
            }
          }
          catch (Exception e) {
            throw new Error(e);
          }
          
          delay(100);
          
        }
      }
    }.start(); // Starts now

    // launch a thread to read err from the process
    new Thread() {
      public void run() {
        while(true) {
          try {
            if (stdErr.ready()) {
              String line;

              while ((line = stdErr.readLine()) != null) {
                try{
                  outputQueue.put(line);
                }
                catch( InterruptedException e ) {
                  println("Interrupted Exception caught");
                }
                
                print(line + '\n');
              }
            }
          }
          catch (Exception e) {
            throw new Error(e);
          }
          
          delay(100);
          
        }
      }
    }.start(); // Starts now


    // and another thread to give data to the process
    new Thread() {
      public void run() {
        while(true) {
//          print("in:");
          String line;
          
          try {
            while (inputQueue.size() > 0) {
              String in = (String)inputQueue.poll();
              print("sending: " + in + "\n");
              stdIn.write(in + "\n");
            }
          } 
          catch (Exception e) {
            throw new Error(e);
          }
          
          delay(100);
          
          try {
            stdIn.flush();
//            stdIn.close();
          } 
          catch (IOException e) { /* Who cares ?*/
          } 
        }
      }
    }
    .start(); // Starts now

  }

  // Notify our writing thread that it should send more data to the process
  void write(String command) {
    try{ 
      inputQueue.put(command);
    }
    catch( InterruptedException e ) {
      println("Interrupted Exception caught");
    }
  }

   
   boolean hasData() {
     return (outputQueue.size() > 0);
   }
   
   String read() {
     return (String) outputQueue.poll();
   }
}

