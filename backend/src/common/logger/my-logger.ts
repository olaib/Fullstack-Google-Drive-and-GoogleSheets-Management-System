
export class MyLogger {
    private static logger = new MyLogger();
  
    static log(message: string) {
      console.log(message);
    }
  
    static error(message: string, trace: string) {
      console.error(message, trace);
    }
  
    static warn(message: string) {
      console.warn(message);
    }
  
    static debug(message: string) {
      console.debug(message);
    }
  }
  