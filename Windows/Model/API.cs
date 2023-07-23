using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.IO;
using AppGo.Controller;
using System.Collections.Specialized;
using System.Security.Cryptography.X509Certificates;

namespace AppGo.Model
{
    public class WebClientCert : WebClient
    {
        //private X509Certificate2 _cert;
        //public WebClientCert(X509Certificate2 cert) : base() { _cert = cert; }
        protected override WebRequest GetWebRequest(Uri address)
        {
            HttpWebRequest request = (HttpWebRequest)base.GetWebRequest(address);
            //if (_cert != null) { request.ClientCertificates.Add(_cert); }
            return request;
        }
        protected override WebResponse GetWebResponse(WebRequest request)
        {
            try
            {
                WebResponse response = null;
                response = base.GetWebResponse(request);
                HttpWebResponse baseResponse = response as HttpWebResponse;
                StatusCode = baseResponse.StatusCode;
                StatusDescription = baseResponse.StatusDescription;
                return response;
            }
            catch(WebException ex)
            {
                if (ex.Status == WebExceptionStatus.ProtocolError)
                {
                    HttpWebResponse response = (HttpWebResponse)ex.Response;
                    StatusCode = response.StatusCode;
                    StatusDescription = response.StatusDescription;
                    return null;
                }
                return null;
            }            
        }
        /// <summary>
        /// The most recent response statusCode
        /// </summary>
        public HttpStatusCode StatusCode { get; set; }
        /// <summary>
        /// The most recent response statusDescription
        /// </summary>
        public string StatusDescription { get; set; }
    }


    public static class API
    {
        public static string BASE_URL = "http://39.108.212.90:99";
        public static string SERVICE_URL = "";
        public static string CLIENT_ID = "q32LOhbxR4p8TVKTbLCiHKO4FbZUTQ5m3wI1YtCc";
        public static string CLIENT_SECRET = "qQB4T6wuMpEqMx8JiJIqrNynQTSrEnsRaJxo71C4";

        public static string HEADER_ACCEPT = "application/vnd.appgogo.v1+json";

        public enum Method
        {
            GET,
            POST
        }

        public static Uri Url(string url)
        {
            return new Uri(SERVICE_URL + "/" + url);
        }
        public static string Register(string jsonContent)
        {
            string[,] headers = new string[,]
            {
                //{ "Accept", HEADER_ACCEPT},
                { "Content-Language", LocalizationManager.CurrentLanguage},                
            };
            
            return callService(SERVICE_URL + "/register", Method.POST, headers, jsonContent);
        }

        /*public static string Login(NameValueCollection values)
        {
            NameValueCollection headers = new NameValueCollection()
            {
                { "Accept", HEADER_ACCEPT },
                { "Content-Language", LocalizationManager.CurrentLanguage }
            };

            return Post(SERVICE_URL + "/login", headers, values);            
        }*/

        public static string Sms(string jsonContent)
        {
            string[,] headers = new string[,]
            {
                //{ "Accept", HEADER_ACCEPT},
                { "Content-Language", LocalizationManager.CurrentLanguage},
            };

            return callService(SERVICE_URL + "/sms", Method.POST, headers, jsonContent);
        }

        private static string callService(string url, Method method, string[,] headers, string jsonContent)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            if (method == Method.GET)
                request.Method = WebRequestMethods.Http.Get;
            else
            {
                request.Method = WebRequestMethods.Http.Post;
                request.ContentType = @"application/x-www-urlencoded";

                System.Text.UTF8Encoding encoding = new System.Text.UTF8Encoding();
                Byte[] byteArray = encoding.GetBytes(jsonContent);
                request.ContentLength = byteArray.Length;

                Stream stream = request.GetRequestStream();
                stream.Write(byteArray, 0, byteArray.Length);
                stream.Close();

                /*using (Stream dataStream = request.GetRequestStream())
                {
                    dataStream.Write(byteArray, 0, byteArray.Length);
                }*/
            }
                        
            request.Accept = HEADER_ACCEPT;
            for (int i = 0; i < headers.Length/2; i++)
            {
                request.Headers.Add(headers[i,0], headers[i,1]);
            }

            try
            {
                WebResponse response = request.GetResponse();
                using (Stream responseStream = response.GetResponseStream())
                {
                    StreamReader reader = new StreamReader(responseStream, System.Text.Encoding.UTF8);
                    return reader.ReadToEnd();
                }
            }
            catch (WebException ex)
            {
                WebResponse errorResponse = ex.Response;
                using (Stream responseStream = errorResponse.GetResponseStream())
                {
                    StreamReader reader = new StreamReader(responseStream, System.Text.Encoding.GetEncoding("utf-8"));
                    String errorText = reader.ReadToEnd();
                    // log errorText
                    return null;
                }
            }
        }


        /*private static string Post(string uri, NameValueCollection headers, NameValueCollection values)
        {
            byte[] response = null;
            using (WebClientCert client = new WebClientCert())
            {
                if (headers.Count > 0)
                {
                    client.Headers.Add(headers);
                }

                response = client.UploadValues(uri, values);
                HttpStatusCode code = client.StatusCode;
                string description = client.StatusDescription;
                //Use this information
            }

            byte[] response = null;
            WebClient client = new WebClient();
            if (headers.Count > 0)
            {
                client.Headers.Add(headers);
            }

            try
            {
                response = client.UploadValues(uri, values);
                return System.Text.Encoding.UTF8.GetString(response);
            }
            catch(Exception e)
            {
                if (e.Status == WebExceptionStatus.ProtocolError)
                {
                    HttpWebResponse response = (HttpWebResponse)ex.Response;
                    if (response.StatusCode == HttpStatusCode.NotFound)
                        System.Diagnostics.Debug.WriteLine("Not found!");
                }
                return null;
            }
        }*/
    }
}
