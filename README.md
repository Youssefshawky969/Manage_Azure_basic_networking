## Overview

This task involved building a Terraform-based Azure infrastructure that implements a Hub-and-Spoke network topology, where a Hub Virtual Network hosts a management Virtual Machine and a Spoke Virtual Network hosts a private Azure App Service. The solution integrates VNet peering for private routing, Private Endpoint for secure PaaS access, and Private DNS Zone for internal name resolution, while applying subnet-level Network Security Groups (NSGs) to enforce network security boundaries. The final architecture ensures that the web application is accessible only from within the private Azure network and completely isolated from public internet access, demonstrating real-world enterprise cloud networking and security design using Infrastructure as Code.

## Workflow Digram
<img width="789" height="762" alt="High-level Diagram drawio" src="https://github.com/user-attachments/assets/2cd79665-481f-4ad9-ba59-2ba6aee2ae4b" />


## Objective of the Task

The objective of this task was to design and deploy
- A secure Hub-and-Spoke Azure network architecture using Terraform,
- where an Azure Virtual Machine in the Hub network securely accesses a private Azure App Service hosted in the Spoke network,
- via Private Endpoint and Private DNS, without exposing the application to the public internet.

This implementation demonstrates infrastructure automation (IaC), private connectivity to PaaS services, network segmentation, DNS integration, and enterprise-grade security best practices such as subnet-level NSG enforcement and VNet peering.

## What Was Implemented so far

Implemented the modules structure
```text
Azure tasks/
|__ provider.tf
|__ main.tf
|__ variables.tf
|__ output.tf
|__ terraform.tfvars
|__ moduels/
   |__ netwotk/
   |__ nsg/
   |__ compute/
   |__ appservice/
   |__ private-endpoint
   |__ dns/
   |__ peering/
```
## Tests Cases
1- SSH Into Hub VM from my custom public IP only

>
>

<img width="815" height="601" alt="image" src="https://github.com/user-attachments/assets/b39dfdfe-80c0-4dad-8dba-36e1e56b0201" />

>
>


2- Test DNS Resolution from the landing VM

>
>

<img width="1306" height="257" alt="image" src="https://github.com/user-attachments/assets/0111a2dc-a776-4128-8733-f387db73adb6" />

>
>

<img width="1891" height="946" alt="image" src="https://github.com/user-attachments/assets/8edccbc3-cc65-4125-952c-b87e4822df95" />

>
>

3- Test From public browser

>
>

<img width="1636" height="614" alt="image" src="https://github.com/user-attachments/assets/c2e41db9-c68c-46d7-a868-b125ce439c35" />

>
>

4- Validate Private Endpoint Connection

>
>

<img width="1912" height="481" alt="image" src="https://github.com/user-attachments/assets/7f904d36-0969-462b-a774-4e7ece393bfa" />

>
>

5- Validate DNS Zone Linking

>
>

<img width="1517" height="508" alt="image" src="https://github.com/user-attachments/assets/277b618c-9ae1-4d26-af87-51485c01c0db" />

>
>









