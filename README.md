# Project Deployment
Deployment files for Kubernetes  

These are the deployment files for the Kubernetes demo. Full installation instructions are as follows

## Docker/Kubernetes Dev Prerequisites
1. Ensure Hyper-V is enabled on Windows
2. Ensure .Net Core v2.1 support is enabled in Visual Studio 2017 (may need to re-run the installer.)
3. Install Docker for Windows Desktop from (latest stable should be fine) https://hub.docker.com/editions/community/docker-ce-desktop-windows 
4. Open the Docker settings and ensure you are running Linux containers and Kubernetes is enabled and set as the orchestrator.
5. You'll need a Git client installed, even if it's just the standard CLI / simple GUI at https://gitforwindows.org/ I've used Git Extensions for several years http://gitextensions.github.io/
6. Install a docker registry locally
   ```
   docker run -d -p 5000:5000 --restart always --name registry registry:2
   ```
## Setup instructions
1. Add the following entries to your hosts file
   ```
   127.0.0.1 customer1.k8sdemo.com
   127.0.0.1 customer2.k8sdemo.com
   ```
1. Create a directory structure c:\k8sdemo\repos
2. In a command line at c:\k8sdemo\repos, clone all the relevant Github repositories

   ```
   git clone https://github.com/ktrickey/houseprice-api.git

   git clone https://github.com/ktrickey/houseprice-import.git

   git clone https://github.com/ktrickey/houseprice-web.git

   git clone https://github.com/ktrickey/houseprice-postcodelookup.git

   git clone https://github.com/ktrickey/houseprice-deploy.git

   git clone https://github.com/ktrickey/houseprice-data.git

   ```
4. We now need to build each of the projects that were cloned above (there's nothing to build the deploy or data repositories).

5. For each project we now need to tag the image and push it to our local repository.
   ```
   docker tag xxxxx localhost:5000\xxxxx:v1.0.0.0
   docker push localhost:5000\xxxxx:v1.0.0.0
   
   docker tag xxxxx localhost:5000\xxxxx:v1.0.0.0
   docker push localhost:5000\xxxxx:v1.0.0.0
   
   docker tag xxxxx localhost:5000\xxxxx:v1.0.0.0
   docker push localhost:5000\xxxxx:v1.0.0.0
   
   docker tag xxxxx localhost:5000\xxxxx:v1.0.0.0
   docker push localhost:5000\xxxxx:v1.0.0.0
   ```
3. Add the following directories
   ```
   md c:\k8sdemo\data
   md c:\k8sdemo\data\customer1
   md c:\k8sdemo\data\customer1\branding
   md c:\k8sdemo\data\customer1\importer
   md c:\k8sdemo\data\customer1\importer\drop
   md c:\k8sdemo\data\customer1\importer\processing
   md c:\k8sdemo\data\customer1\importer\success
   md c:\k8sdemo\data\customer2\branding
   md c:\k8sdemo\data\customer2\importer
   md c:\k8sdemo\data\customer2\importer\drop
   md c:\k8sdemo\data\customer2\importer\processing
   md c:\k8sdemo\data\customer2\importer\success
   ```

4. Add a site.css file to the two branding directories in step 8

   Customer 1 site.css
   ```
   body {
   
   }
   ```
   Customer 2 site.css
   ```
   body {
	background-color: #f00 !important
   }
   ```
5. In an admin command line at c:\k8sdemo\repos\houseprice-deploy run
   ```
   InitialDeploy.cmd
   ```
6. To enable the Kubernetes dashboard, in a separate command window run
   ```
   kubectl proxy
   ```
7. In a browser, navigate to 
   ```
   http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/deployment?namespace=default
   ```
   You should now be able to navigate around the dashboard and find the services, pods etc that have been set up. You'll need to select the customer1 or customer2 namespaces to see the customer specific resources.
8. Copy c:\k8sdemo\repos\houseprice-data\2018-cust1.csv to c:\k8sdemo\data\customer1\importer\drop
9. Copy c:\k8sdemo\repos\houseprice-data\2018-cust1.csv to c:\k8sdemo\data\customer2\importer\drop
10. The files should move to the processing directory and then to the success directory
11. Navigate to http://customer1.k8sdemo.com:8080 and try searching
11. Navigate to http://customer2.k8sdemo.com:8080 and try searching (background colour should be different to customer1)