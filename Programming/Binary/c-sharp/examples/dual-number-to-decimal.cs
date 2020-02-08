/*
 * Install mono, compile, run:
 * sudo apt install mono-devel # Maybe: mono-complete
 * mcs dual-number-to-decimal.cs && mono dual-number-to-decimal.exe
 */

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1 {
    class Program {
        static void Main(string[] args) {
            int i = 0;
            int[] array = new int[8];
            int result = 0;
            string dualNumber = "";
            int input;
            string read;

            Console.WriteLine("Enter a dual number (max. 8 digits, confirm each digit with RETURN):");

            for (i = 7; i >= 0; ) {
                //input = Convert.ToInt32(Console.ReadLine());

                read = Console.ReadLine();
                if (!Int32.TryParse(read, out input)) {
                    input = -1;
                }

                if (input == 1 || input == 0) {
                    array[i] = input;
                    i--;
                } else {
                    Console.WriteLine("Numbers other than 1 and 0 are not possible in the dual number system!");
                }
            }

            for (i = 7; i >= 0; i--) {
                dualNumber += array[i];
                result += Convert.ToInt32(Math.Pow(2, i) * array[i]);
            }

            string spacer = "     ";
            if (result < 10) {
                spacer += " ";
            }
            if (result < 100) {
                spacer += " ";
            }
            Console.WriteLine();
            Console.WriteLine("Input value as a dual number:\t" + dualNumber);
            Console.WriteLine("Input value as a decimal number:\t" + spacer + "{0}", result);
            Console.ReadLine();
        }
    }
}
