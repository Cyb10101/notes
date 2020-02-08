/*
 * Install mono, compile, run:
 * sudo apt install mono-devel # Maybe: mono-complete
 * mcs menu.cs && mono menu.exe
 */

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/*
 * Console.WriteLine("Werte: {0} / {1} = {2}", a, b, c);
 */
namespace ConsoleCyb {
	class Cyb {
		static void Main(string[] args) {
			Menu();
		}

		static void Menu() {
			Console.Clear();
			cyb_echo("spacer1");
			cyb_echo("title", " Command [/]");
			cyb_echo("spacer1");

			cyb_option("1", "-");
			cyb_option("2", "-");
			cyb_option("3", "-");
			Console.WriteLine();
			cyb_option("4", "Calculate");
			cyb_option("5", "-");
			cyb_option("6", "-");
			Console.WriteLine();
			cyb_option("7", "Console colors");
			cyb_option("8", "-");
			cyb_option("9", "-");
			Console.WriteLine();
			cyb_option("0 | ESC", "Exit");
			Console.WriteLine();

			Console.Write("Command: ");
			ConsoleKeyInfo readkey = Console.ReadKey();
			Console.WriteLine();
			cyb_echo("spacer2");

			if (readkey.KeyChar == '1') {
				Console.WriteLine("Choosen 1");
				cyb_pause();
				Menu();
			} else if (readkey.KeyChar == '2') {
				Console.WriteLine("Choosen 2");
				cyb_pause();
				Menu();
			} else if (readkey.KeyChar == '3') {
				Console.WriteLine("Choosen 3");
				cyb_pause();
				Menu();
			} else if (readkey.KeyChar == '4') {
				Menu_Calculate();
			} else if (readkey.KeyChar == '5') {
				Console.WriteLine("Choosen 5");
				cyb_pause();
				Menu();
			} else if (readkey.KeyChar == '6') {
				Console.WriteLine("Choosen 6");
				cyb_pause();
				Menu();
			} else if (readkey.KeyChar == '7') {
				Run_Console_Color();
				cyb_pause();
				Menu();
			} else if (readkey.KeyChar == '8') {
				Console.WriteLine("Choosen 8");
				cyb_pause();
				Menu();
			} else if (readkey.KeyChar == '9') {
				Console.WriteLine("Choosen 9");
				cyb_pause();
				Menu();
			} else if (readkey.KeyChar == '0' || readkey.Key == ConsoleKey.Escape) {
				//return(0);
			} else {
				Console.WriteLine("Incorrect input!");
				cyb_pause();
				Menu();
			}
		}

		static void Menu_Calculate() {
			int command;

			Console.Clear();
			cyb_echo("spacer1");
			cyb_echo("title", " Command [/Calculate/]");
			cyb_echo("spacer1");

			cyb_option("1", "Decimal in binary");
			cyb_option("2", "Binary in decimal");
			cyb_option("3", "-");
			Console.WriteLine();
			cyb_option("4", "-");
			cyb_option("5", "-");
			cyb_option("6", "-");
			Console.WriteLine();
			cyb_option("7", "-");
			cyb_option("8", "-");
			cyb_option("9", "-");
			Console.WriteLine();
			cyb_option("0", "Back");
			Console.WriteLine();

			Console.Write("Command: ");
			string read = Console.ReadLine();
			cyb_echo("spacer2");
			if(!Int32.TryParse(read, out command)) {command = -1;}

			if(read == "") {
				Menu_Calculate();
			} else if (command == -1) {
				Console.WriteLine("Incorrect input!");
				cyb_pause();
				Menu_Calculate();
			} else if (command == 1) {
				Run_Calc_Binar(1);
				cyb_pause();
				Menu_Calculate();
			} else if (command == 2) {
				Console.WriteLine("Choosen 2");
				cyb_pause();
				Menu_Calculate();
			} else if (command == 0) {
				Menu();
			} else {Menu_Calculate();}
		}

		static void cyb_echo(string type, string text = "") {
			string temp = "";
			if(type == "spacer1") {
				for(int i = 1; i <= 80; i++) {temp += "=";}
				//cyb_color(temp, "DarkBlue", "");
				//Console.WriteLine("");
				Console.WriteLine(temp);
			} if(type == "spacer2") {
				for(int i = 1; i <= 80; i++) {temp += "-";}
				Console.WriteLine(temp);
			} if(type == "title") {
				for(int i = (1 + text.Length); i <= 76; i++) {temp += " ";}
				//cyb_color("= ", "DarkBlue", "");
				//cyb_color(text + temp, "", "");
				//cyb_color(" =", "DarkBlue", "");
				//Console.WriteLine("");
				Console.WriteLine("= " + text + temp + " =");
			} else {}
		}

		static void cyb_option(string option, string text = "") {
			Console.WriteLine(" [" + option + "] " + text);
		}

		static void cyb_color(string text, string fore, string back) {
			Type type = typeof(ConsoleColor);
			if(fore == "") {fore = "White";}
			if(back == "") {back = "Black";}

			Console.ForegroundColor = (ConsoleColor)Enum.Parse(type, fore);
			Console.BackgroundColor = (ConsoleColor)Enum.Parse(type, back);
			Console.Write(text);
			Console.ForegroundColor = ConsoleColor.White;
			Console.BackgroundColor = ConsoleColor.Black;
		}

		static void cyb_pause(string text = "") {
			if(text == "") {
				Console.Write("Any key to continue...");
			} else {
				Console.Write(text + " ");
			}
			Console.ReadKey();
			Console.WriteLine("");
		}

        static void Run_Calc_Binar(int id = 1) {
			if(id == 1) {
				int temp = 0;
				int decimalNumber = 0;
				int[] dual = new int[9];

				do {
					Console.Write("Enter a decimal number between 0 and 255: ");
					string read = Console.ReadLine();
					if(!Int32.TryParse(read, out decimalNumber)) {decimalNumber = -1;}

					if (decimalNumber < 0 || decimalNumber > 255) {
						Console.WriteLine("Your entry is invalid!\n");
					}
				}
				while (decimalNumber < 0 || decimalNumber > 255);

				dual[8] = decimalNumber % 2;
				temp = decimalNumber / 2;

				dual[7] = temp % 2;
				temp = temp / 2;

				dual[6] = temp % 2;
				temp = temp / 2;

				dual[5] = temp % 2;
				temp = temp / 2;

				dual[4] = temp % 2;
				temp = temp / 2;

				dual[3] = temp % 2;
				temp = temp / 2;

				dual[2] = temp % 2;
				temp = temp / 2;

				dual[1] = temp % 2;
				temp = temp / 2;

				Console.WriteLine("Decimal:\t" + decimalNumber);
				Console.Write("Binary:\t\t");
				for (int i = 1; i < 9; i++) {Console.Write(dual[i]);}
				Console.WriteLine();
				cyb_echo("spacer2");
			}
		}

        static void Run_Console_Color() {
			Type type = typeof(ConsoleColor);

			Console.WriteLine("[Background color | Foreground color]");
			foreach (var name in Enum.GetNames(type)) {
				Console.Write(" ");

				Console.ForegroundColor = ConsoleColor.White;
				Console.BackgroundColor = (ConsoleColor)Enum.Parse(type, name);
				Console.Write(" " + name + " ");
				Console.BackgroundColor = ConsoleColor.Black;

				Console.ForegroundColor = ConsoleColor.White;
				Console.BackgroundColor = ConsoleColor.Black;
				if(name.Length < 5) {Console.Write("\t");}
				Console.Write("\t  | ");

				Console.ForegroundColor = (ConsoleColor)Enum.Parse(type, name);
				Console.BackgroundColor = ConsoleColor.Black;
				Console.Write(" " + name + " ");
				Console.ForegroundColor = ConsoleColor.White;

				Console.WriteLine();
			}
			Console.ForegroundColor = ConsoleColor.White;
			Console.BackgroundColor = ConsoleColor.Black;
			cyb_echo("spacer2");
		}

		/*
		 * if(Get_System("platform") == "Unix")
		 */
		static string Get_System(string get) {
			OperatingSystem os = Environment.OSVersion;
			if(get == "platform") {
				return os.Platform.ToString();
			} else {return "";}

			/*
			Console.WriteLine("OS Version: " + os.Version.ToString());
			Console.WriteLine("OS Platform: " + os.Platform.ToString());
			Console.WriteLine("OS SP: " + os.ServicePack.ToString());
			Console.WriteLine("OS Version String: " + os.VersionString.ToString());
			Console.WriteLine();

			Version ver = os.Version;
			Console.WriteLine("Version: " + ver.Major + "." + ver.MajorRevision + "." + ver.Minor + "." + ver.MinorRevision + "-" + ver.Build);
			*/
		}
	}
}
