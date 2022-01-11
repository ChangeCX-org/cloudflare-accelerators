/**
 * @author ChangeCX (Dasa Ponnappan)
 * This worker accesses the name space named REWRITE_MAP mapped to KV store and tries to get a value assocaited to the Key (Which is request.url)
 */


addEventListener("fetch", event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  
  console.log("The request url is " + request)
  const urlPath = new URL(request.url)
  const value = await REWRITE_MAP.get(urlPath.pathname)
  console.log("The URL to be redirected for the provided URL:"+urlPath.pathname+" is :"+value)  
  urlVal=""
  if(value) {
    urlVal = "https://"+urlPath.host+value
  }else {
    urlVal = request.url
  }  
  return fetch(new Request(urlVal, {
    body: request.body,
    headers: request.headers,
    method: request.method,
    redirect: request.redirect
  })
)
}
