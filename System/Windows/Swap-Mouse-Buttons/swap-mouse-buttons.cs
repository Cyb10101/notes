using System;
using System.Runtime.InteropServices;

class SwapMouse {
    [DllImport("user32.dll")]
    public static extern Int32 SwapMouseButton(Int32 bSwap);

    static void Main(string[] args) {
        int rightButtonIsAlreadyPrimary = SwapMouseButton(1);
        if (rightButtonIsAlreadyPrimary != 0) {
            SwapMouseButton(0);  // Make the left mousebutton primary
            Console.WriteLine("Primary: Left mouse");
        } else {
          Console.WriteLine("Primary: Right mouse");
        }
        System.Threading.Thread.Sleep(3000);
    }
}
