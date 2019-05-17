---

---

[TOC]

# Quickstart container in the Azure cloud

To be able to run this quickstart, you need to have the following components:

* On your laptop: 
  * Docker (for Windows or Mac) <https://www.docker.com/products/docker-desktop>
  * Azure CLI <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest>
* In the cloud: access to an Azure cloud subscription. You can create a free account at [https://azure.microsoft.com/en-us/free](https://azure.microsoft.com/en-us/free/)[/](https://azure.microsoft.com/en-us/free/) 



## Using public Docker images

We start with using public available images on Docker Hub and see the difference between running it locally and the same in the cloud.

We will use 2 images: MySQL and PHPMyAdmin. The latter image is a web application which is an administration tool for MySQL (or MariaDB) which is used by many web hosting providers.



### Local

Open a command prompt / terminal window and type:

`docker run -d --name db1 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=r00tr00t -e MYSQL_DATABASE=db -e MYSQL_USER=db_user -e MYSQL_PASSWORD=dbpwd123 mysql`

This will pull the MySQL (latest) image from Docker Hub and create a MySQL Docker container with a database called `db1` and set a root password and create an additional user `db_user`.

Next create the container with the administration tool by typing:

`docker run -d --name mydbadmin --link db1:db -p 8080:80 phpmyadmin/phpmyadmin`

The `--link` command will give the container access to the other container. 

For more information about both Docker images, see their Docker Hub pages:

* <https://hub.docker.com/_/mysql>
* <https://hub.docker.com/r/phpmyadmin/phpmyadmin>



Check if both containers are running: `docker ps`



Now open a web browser and go to http://localhost:8080

![phpmyadmin_local_login](img/phpmyadmin_local_login.png)

Try to login as db_user.

You probably get some errors about the authentication method used. This has to do with a change in MySQL v8 which we are using. We can solve this by updating the password in the MySQL database.

On the command prompt, type:

`docker exec -it db1 bash`

Now you are logged in the MySQL container.

Type: `mysql -u root -pr00tr00t` (use the same password for root as used when you created the container).

 Now update the password for the `db_user` user:

`alter user db_user identified with mysql_native_password by 'secretuserpassword';`

Type: `exit` and `exit` again to return to your local command prompt.

Now try again to login.

![phpmyadmin_local_homepage](img/phpmyadmin_local_homepage.png)

If you go to the Databases tab you will see the `db` database without any tables.

Ok. That is working.

Now we try the same in the Azure cloud.



### Azure cloud

There are multiple ways to create containers in Azure. We will start with using the Azure Portal.

#### Azure Portal

In your browser go to https://portal.azure.com and login into your Azure subscription.

First we will create a new resource group in which we will add our container. Creating a resource group makes it easier to find your components but also to clean it up.

Press the `Create a resource` link in the left sidebar.

Search for `Resource Group` .

![](img/azure_create_resource_group.png)

Press the `Create` button.

Select a subscription and enter a name for the new resource group, e.g. `containertest`

Select a region, e.g.: `West Europe`.

Press `Review + Create` and then `Create`.

Resource groups are just a grouping of Azure components, there are no costs involved, so you can create as many resource groups as you like (if you are allowed to do so).

Now we will add the MySQL container.

In Azure single Docker containers are created in a component called Azure Container Instance (which is a wrapper for one or more containers). For more information, see the [Azure documentation](https://docs.microsoft.com/en-us/azure/container-instances/). 



Lets create the container.

Press the `Create a resource` link again and search for `container instance` or let's do it another way. Because you can navigate to the home tab of all your container instances by pressing the `All Services` link in the side bar and search for `container instances`.  If you click on the star next to the Container instances services, the link to the home tab will be added to the side bar.

 ![](img/azure_services_container_instances.png)

Now press the `Container instance` link and the home tab for all container instances will be shown.

Now press the `Add` button.

On the first page, select the previous created resource group. And enter a name for the container.

Select the region (which is probably already set correctly). 

We will use a public image, so the Image Type is Public.

Enter the image name: `mysql`.

Set OS Type to Linux.

And leave the size to 1 cpu and 1.5 GB.

![](img/azure_create_container_mysql_1.png)

Press Next.

Set Include public IP adress to Yes.

Change the default port 80 to 3306.

Set the DNS name label to something (global) unique: 

Press Next.

On the next page enter the same environment variables you used when creating the container locally.

 ![](img/azure_create_container_mysql_3.png)

Press Review+Create.

Press Create.

The container will now be created.

![](img/azure_create_container_mysql_deploy.png)

When ready click on `Go to resource`.

Make a note of the FQDN (the DNS name the container can be accessed on). We need that for our second container.

Now add another container for PHPMyAdmin.

![](img/azure_create_container_phpmyadmin_1.png)

On the networking tab leave the port tot 80 (currently it is not possible to map a container port to another port as we do locally).

Set a DNS name label.

Press Next.

On the advanced tab, add two environment settings:

PMA_HOST = <dns name of the mysql container>

PMA_PORT = 3306

![](img/azure_create_container_phpmyadmin_3.png)

And create the container.

Also here we will have the same issue with authentication.

Go to the db1 container and open the `Container` subpage and then the `Connect` tab.

![](img/azure_container_instance_mysql_connect.png)

Select /bin/bash and press Connect.

And perform the same steps as you have locally to update the `db_user` password.

And log into PHPMyAdmin. You can find the url on the overview page of the dbadmin container.

And check if you can log in.



Now if you really want to use the database, you will need some persistent storage. Otherwise any change you make to the current running container instance will be lost at restart time of the container. Note that this is different from running it locally. On your local machine the data will remain as long as the container has not been deleted. 

Unfortunately you can not add volumes in the Azure portal like you do locally. But it can be done using the Azure CLI. 

If not done already install Azure CLI on your machine (see the prerequisites).



#### Azure CLI

Azure CLI is a set of commands you can use on the command prompt / terminal. On Windows you can use either command prompt, powershell or WSL (Windows Subsystem for Linux) for this.

The first step is to connect your machine to your Azure account.

Open the command prompt / terminal and type:

`az login`

A browser window will appear and you will need to log into your Azure account. If you have done this, you are ready to go.

We already created the resource group via the portal, but if you wish to create a resource group via Azure CLI, use the following command:

`az group create --name containertest --location westeurope`

Next we create a storage account to store our files for the mysql container:

`az storage account create --name sadb001files --resource-group containertest --sku Standard_LRS` (use any name you like, but only lowercase alphanumeric characters are allowed).

Next create a file share on this account which we will use a a volume mount for the container. You need the connection string to the created storage account for this. You can either find it in the azure portal or use the following azure cli command: `az storage account show-connection-string --name sadbfiles --resource-group containertest -o tsv`.

`az storage share create --name dbfileshare --connection-string "..."` (note that the connection string must be enclosed by quotes).

For the volume mount you need the account key for the storage. Use the following azure cli command to retrieve this: `az storage account keys list --resource-group containertest --account-name sadbfiles --query "[0].value" --output tsv`.

Next we will create the MySQL container:

```bash
az container create --resource-group containertest --location westeurope --name db2 --image mysql --ip-address public --port 3306 --cpu 1 --memory 1.5 --dns-name-label db2 --environment-variables MYSQL_ROOT_PASSWORD=secretpasspass MYSQL_DATABASE=db MYSQL_USER=db_user MYSQL_PASSWORD=dbpwd123 --azure-file-volume-account-name sadbfiles --azure-file-volume-account-key "..." --azure-file-volume-share-name dbfileshare --azure-file-volume-mount-path /var/lib/mysql
```

And create the PHPMyAdmin container:

```bash
az container create --resource-group containertest --location westeurope --name dbadmin2 --image phpmyadmin/phpmyadmin --ip-address public --port 80 --cpu 1 --memory 1.5 --dns-name-label dbadmin2 --environment-variables PMA_HOST=db2.westeurope.azurecontainer.io PMA_PORT=3306
```

Also here: update password for the MySQL user and then try to connect using the new PHPMyAdmin container.

Create a table and add some data.

Now stop and start the mysql container and check if the data is still available.

And do the same with the mysql container you created using the portal.

You should see that the second created container still has its data and the first one does not.

> **There is one major note to mention: the container are now running in the cloud and can be accessed over the internet, so if you want to run these containers for a longer period of time you MUST add security measurements!** 