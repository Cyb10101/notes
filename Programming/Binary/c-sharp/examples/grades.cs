/*
 * Install mono, compile, run:
 * sudo apt install mono-devel # Maybe: mono-complete
 * mcs grades.cs && mono grades.exe
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleGrades {
    class Grades {
        static void Main(string[] args) {
            int exit = 0;
            int amount;
            string read;
            string[] noten_text = new string[7];
            noten_text[1] = "Very good";
            noten_text[2] = "Good";
            noten_text[3] = "Satisfactory";
            noten_text[4] = "Sufficient";
            noten_text[5] = "Poor";
            noten_text[6] = "Insufficient";

            while(exit != 1) {
                Console.Write("Please enter the number of field elements [1-10]: ");
                read = Console.ReadLine();
                if(!Int32.TryParse(read, out amount)) {amount = -1;}

                if(amount >= 1 && amount <= 10) {
                    string[] faecher = new string[amount];
                    int[] noten = new int[amount];
                    Console.WriteLine();

                    for(int i = 0; i < amount; i++) {
                        Console.Write("Please enter subject [Math, Sport, ...]: ");
                        faecher[i] = Console.ReadLine();

                        do {
                            Console.Write("Please enter a note from " + faecher[i] + " [1-6]: ");
                            read = Console.ReadLine();
                            if(!Int32.TryParse(read, out noten[i])) {noten[i] = -1;}
                        } while(!(noten[i] >= 1 && noten[i] <= 6));

                        Console.WriteLine();
                    }

                    for(int i = 0; i < amount; i++) {
                        Console.WriteLine(faecher[i] + " = " + noten_text[noten[i]]);
                    }
                    Console.WriteLine();

                    exit = 1;
                } else {
                    Console.WriteLine("Your entry was incorrect!");
                    Console.WriteLine();
                }
            }
        }
    }
}
