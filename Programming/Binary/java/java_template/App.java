// javac App.java && java App
// javac App.java && jar -c -f App.jar -e App *.class Utility/*.class && java -jar App.jar
import Utility.Tools;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello World");

        Tools tools = new Tools();
        System.out.println("Result: " + tools.add(3, 5));
    }
}