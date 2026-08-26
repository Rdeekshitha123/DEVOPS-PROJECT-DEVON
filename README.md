AWS DevOps Stack: Terraform + Docker + GitHub Actions Automation

📋 Project Overview

Problem Statement
Organizations struggle with manual infrastructure deployment, inconsistent environments, and lack of scalability. Traditional methods lead to configuration drift, prolonged deployment times, and difficulty managing multiple environments (dev, staging, prod).



Objectives :

- Automate infrastructure provisioning using Infrastructure as Code (Terraform)
- Containerize applications for consistency across environments
- Implement auto-scaling for dynamic load management
- Ensure high availability through load balancing
- Secure access without SSH key management (using IAM + Systems Manager)
- Centralize state management with remote backend



Tech Stack : 

IaC - Terraform 
Cloud - AWS (EC2, ASG, ALB, VPC, IAM, S3, DynamoDB)
Containerization - Docker, Nginx Alpine, Node.js 18 Alpine 
Application - React based Zomato application
State Management -  S3 backend + DynamoDB locking 


