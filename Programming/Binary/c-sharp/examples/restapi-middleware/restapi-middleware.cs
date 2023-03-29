/*
 * docker-compose build && docker-compose down && docker-compose up -d && docker-compose logs -f
 * curl -X POST -H  "Accept: application/json" -H  "Content-Type: application/json" -d '{id: 123, name: "Bean", enabled: true}' 'http://127.0.0.1:8080'
 *
 * Optional: docker-compose exec app bash
 */

using System.Web.Script.Serialization;
using System;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp {
    class App {
        private static async Task ApiPost(string url, string jsonContent) {
            using (var client = new HttpClient()) {
                var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");
                var response = await client.PostAsync(url, content);

                if (response.IsSuccessStatusCode) {
                    Console.WriteLine("Successful POST request.");

                    var responseContent = response.Content.ReadAsStringAsync().Result;
                    Console.WriteLine("API2 Response:\n" + responseContent);
                } else {
                    Console.WriteLine("POST request failed with status code: " + response.StatusCode);
                }
            }
        }

        public class Person {
            public int id { get; set; }
            public string name { get; set; }
            public bool enabled { get; set; }
        }

        private static string GetJsonDataFromRequest(HttpListenerRequest request) {
            using (var reader = new System.IO.StreamReader(request.InputStream, request.ContentEncoding)) {
                return reader.ReadToEnd();
            }
        }

        static void Main(string[] args) {
            var listener = new HttpListener();
            listener.Prefixes.Add("http://*:80/");
            listener.Start();

            Console.WriteLine("Listening for incoming data...");

            while (true) {
                var context = listener.GetContext();
                var request = context.Request;
                var response = context.Response;

                if (request.HttpMethod == "POST" && request.Url.AbsolutePath == "/") {
                    var jsonData = GetJsonDataFromRequest(request);
                    Console.WriteLine("Received JSON data: " + jsonData);

                    var serializer = new JavaScriptSerializer();
                    // dynamic data = serializer.DeserializeObject(jsonData);
                    var person = serializer.Deserialize<Person>(jsonData);
                    Console.WriteLine("Person id: " + person.id);
                    Console.WriteLine("Person name: " + person.name);
                    Console.WriteLine("Person registred: " + person.enabled);
                    
                    person.id = person.id + 1;
                    person.name = person.name + " is the best";
                    person.enabled = !person.enabled;
                    var serializedResult = serializer.Serialize(person);
                    ApiPost("https://httpbin.org/post", serializedResult).Wait();

                    var buffer = Encoding.UTF8.GetBytes("Data successfully processed\n");
                    response.ContentLength64 = buffer.Length;
                    var output = response.OutputStream;
                    output.Write(buffer, 0, buffer.Length);
                } else {
                    response.StatusCode = (int)HttpStatusCode.BadRequest;
                }

                response.Close();
            }
        }
    }
}
