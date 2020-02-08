/*
 * Install mono, compile, run:
 * sudo apt install mono-devel # Maybe: mono-complete
 * mcs random-array.cs && mono random-array.exe
 */

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1 {
    class Program {
        static void Main(string[] args) {
            int amount = 1;

            while(amount != 0) {
                Console.WriteLine("How many field elements should be filled with random numbers?");
                amount = Convert.ToInt32(Console.ReadLine());
                Console.WriteLine();

                if (amount >= 1 && amount <= 100) {
                    int[] results = new int[amount];

                    Random randomNumber = new Random();
                    for (int i = 0; i < amount; i++) {
                        int rnd = randomNumber.Next(1, 100);
                        results[i] = rnd;
                    }
                    Console.WriteLine();

                    foreach (int i in results) {
                        if (i < 10) {
                            Console.Write("  " + i);
                        } else {
                            Console.Write(" " + i);
                        }
                    }
                    Console.WriteLine();
                    for (int i = (results.Length - 1); i >= 0; i--) {
                        if (results[i] < 10) {
                            Console.Write("  " + results[i]);
                        } else {
                            Console.Write(" " + results[i]);
                        }
                    }
                    Console.WriteLine();

                    string exit = "";
                    while (exit == "") {
                        Console.WriteLine("Would you like to end the program [y/n]");
                        exit = Console.ReadLine();

                        if (exit == "y") {
                            amount = 0;
                        } else if (exit != "n") {
                            Console.WriteLine("Invalid Input");
                            exit = "";
                        }
                    }
                } else {
                    Console.WriteLine();
                    Console.WriteLine("The number must be between 1 and 100!");
                }
            }
        }
    }
}
