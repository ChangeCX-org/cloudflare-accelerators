# cloudflare-accelerators
## Cloudflare Accelerators from ChangeCX provides re-usable components that helps build workers on the edge. 
### Dockerfile Structure 
<ol> 
<li>The common pattern is to have a Dockerfile that builds an UBUNTU 20.x image </li>
<li> Installs node (npm) latest version </li>
<li> Installs python 3.9 Version </li>
<li> Installs <code>bash</code> <code>less</code> <code>wget</code> <code>curl</code> commands </li>
<li> Copies base folder of cloudflare-accelerators repository </li>
<li> Installs wrangler <code> npm i @cloudflare/wrangler -g </code> </li>
<li> Executes the python code <code>python3 src/txtToJsonConvert.py </code> to generate <code>rewrites.json file</code> </li>
<li> One the file is generated, its uploaded to Cloudflare workers Key Value Store (KV) using <code>sudo wrangler kv:bulk put --namespace-id=<NAME_SPACE_ID_OF_KV_STORE> rewrites/rewrites.json </code> </li>
</ol>

## Configurations
### Configuring Cloudflare login for executing wrangler app

<ol>
<li> Configure Cloudflare Outside Docker Container using <code>sudo wrangler login</code> </li>
<li> This command would open the default browser and allows the user to authenticate to Cloudflare</li>
<li> Once the login to Cloudflare is successful, the credentials of cloudflare are written to current machine's profile's .wrangler folder as default.toml</li>
<li> On Mac, the location of the file would be <code>/Users/$CURRENTUSER/.wrangler/config/default.toml</code> </li>
<li> Copy this file to docker container's $HOME/.wrangler/config. In case of the wrangler folder doesn't exist, create it </li>
</ol>

### Uploading rewrites.json to kv store of Cloudflare 
<ol>
<li> <code>sudo wrangler kv:bulk put --namespace-id=<NAME_SPACE_ID_OF_KV_STORE> ../rewrites/rewrites.json </code> </li> 
</ol>
