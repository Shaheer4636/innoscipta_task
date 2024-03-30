# Table of Contents

1. [AWS EKS Cluster Setup with Terraform](#aws-eks-cluster-setup-with-terraform)
2. [Creating Helm Chart](#creating-helm-chart)
3. [Modifying Dockerfile for Kubernetes](#modifying-dockerfile-for-kubernetes)
4. [Implementing CI/CD with Jenkins](#implementing-cicd-with-jenkins)
5. [Adding IAM User for AWS Access](#adding-iam-user-for-aws-access)
6. [Documentation](#documentation)
7. [Final Steps](#final-steps)

---

## 1. AWS EKS Cluster Setup with Terraform

- We used Terraform to provision a basic AWS EKS cluster named innoscripta-task.
- The Terraform configuration is provided in the repository's `main.tf` file.
- We configured the cluster to have a desired size of 2 nodes, with a minimum of 1 node and a maximum of 5 nodes.
  
  ![AWS EKS Cluster Setup](https://github.com/Shaheer4636/innoscipta_task/blob/main/1%20(2).jpeg)

## 2. Creating Helm Chart

- We created a Helm chart to deploy the Laravel application.
- The Helm chart includes a `Deployment.yaml` file specifying the deployment of the application with three replicas.
- The Helm chart enables easy deployment and management of the application on Kubernetes.
  
  ![Creating Helm Chart](https://github.com/Shaheer4636/innoscipta_task/blob/main/2.jpeg)

## 3. Modifying Dockerfile for Kubernetes

- The existing Dockerfile in the repository was modified to ensure compatibility with Kubernetes deployment.
- The Dockerfile was updated to copy application files into the image and expose the necessary ports.

## 4. Implementing CI/CD with Jenkins

- We set up CI/CD pipelines using Jenkins.
- The Jenkins pipeline script defines three stages: Test, Build, and Deploy.
- The Test stage runs PHPUnit tests on the application code.
- The Build stage builds the Docker image for the application and pushes it to AWS ECR.
- The Deploy stage deploys the application to the AWS EKS cluster using Helm.
  
  ![Implementing CI/CD with Jenkins](https://github.com/Shaheer4636/innoscipta_task/blob/main/3.jpeg)

## 5. Adding IAM User for AWS Access

- We created an IAM user in AWS with limited access permissions to EKS and ECR. 
- Access Key and Secret Key were generated for the IAM user and securely stored.
