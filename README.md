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
1. Configure Docker by right clicking the Docker icon in the system tray and selecting settings and making the following changes
```
   Shared Drives : Select c and apply, enter your domain password if prompted
   Advanced: Set CPUs to 4 and Memory to 4096 
      (these are max values, they don't grab those resources. Two copies of Mongo in the cluster takes a fair bit of resource)
   Daemon: Add localhost:5000 to the insecure registries list
   Kubernetes: Check the Enable Kubernetes option and Apply

```
2. Add the following entries to your hosts file
   ```
   127.0.0.1 customer1.k8sdemo.com
   127.0.0.1 customer2.k8sdemo.com
   ```
2. Create a directory structure c:\k8sdemo\repos
2. In a command line at c:\k8sdemo\repos, clone all the relevant Github repositories

   ```
   git clone https://github.com/ktrickey/houseprice-api.git

   git clone https://github.com/ktrickey/houseprice-import.git

   git clone https://github.com/ktrickey/houseprice-web.git

   git clone https://github.com/ktrickey/houseprice-postcodelookup.git

   git clone https://github.com/ktrickey/houseprice-deploy.git

   git clone https://github.com/ktrickey/houseprice-data.git

   ```

5. For each project we now need to build and push image and push it to our local repository.
   ```
   cd c:\k8sdemo\repos\houseprice-api\src\houseprice.webapi
   docker build -t "localhost:5000/housepricewebapi:1.0.0.0" -f "c:\k8sdemo\repos\houseprice-api\src\houseprice.webapi\dockerfile" ".."
   docker push localhost:5000/housepricewebapi:1.0.0.0
   
   cd C:\k8sdemo\repos\houseprice-web\src\HousePrices.Web
   docker build -t "localhost:5000/housepriceweb:1.0.0.0" -f "C:\k8sdemo\repos\houseprice-web\src\HousePrices.Web\Dockerfile" ".."
   docker push localhost:5000/housepriceweb:1.0.0.0
   
   cd C:\k8sdemo\repos\houseprice-postcodelookup\HousePrice.Postcodes
     docker build -t "localhost:5000/postcodelookup:1.0.0.0" -f "C:\k8sdemo\repos\houseprice-postcodelookup\HousePrice.Postcodes\Dockerfile" ".."
   docker push localhost:5000/postcodelookup:1.0.0.0
   
   cd C:\k8sdemo\repos\houseprice-import\src\HousePrice.Api.ImportFileWatcher
       docker build -t "localhost:5000/housepriceimporter:1.0.0.0" -f "C:\k8sdemo\repos\houseprice-import\src\HousePrice.Api.ImportFileWatcher\Dockerfile" ".."
   docker push localhost:5000/housepriceimporter:1.0.0.0
   ```
3. Add the following directories
   ```
   md c:\k8sdemo\data
   md c:\k8sdemo\data\postcodes
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
   http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default
   ```
   You should now be able to navigate around the dashboard and find the services, pods etc that have been set up. You'll need to select the customer1 or customer2 namespaces to see the customer specific resources.
8. Copy c:\k8sdemo\repos\houseprice-data\2018-cust1.csv to c:\k8sdemo\data\customer1\importer\drop
9. Copy c:\k8sdemo\repos\houseprice-data\2018-cust1.csv to c:\k8sdemo\data\customer2\importer\drop
10. The files should move to the processing directory and then to the success directory
11. Navigate to http://customer1.k8sdemo.com:8080 and try searching
11. Navigate to http://customer2.k8sdemo.com:8080 and try searching (background colour should be different to customer1)