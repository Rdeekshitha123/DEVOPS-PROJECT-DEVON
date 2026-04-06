DevOps Infrastructure Project

📋 Project Overview

Problem Statement
Organizations struggle with manual infrastructure deployment, inconsistent environments, and lack of scalability. Traditional methods lead to configuration drift, prolonged deployment times, and difficulty managing multiple environments (dev, staging, prod).

Objectives
- Automate infrastructure provisioning using Infrastructure as Code (Terraform)
- Containerize applications for consistency across environments
- Implement auto-scaling for dynamic load management
- Ensure high availability through load balancing
- Secure access without SSH key management (using IAM + Systems Manager)
- Centralize state management with remote backend


🛠️ Tech Stack
IaC - Terraform 
Cloud - AWS (EC2, ASG, ALB, VPC, IAM, S3, DynamoDB)
Containerization - Docker, Nginx Alpine, Node.js 18 Alpine 
Application - React based Zomato application
State Management -  S3 backend + DynamoDB locking 



🏗️ Architecture Flow Diagram

┌─────────────────────────────────────────────────────────┐
│                     Internet Users                       │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
         ┌───────────────────────────────┐
         │  Internet Gateway (IGW)       │
         └───────────────────┬───────────┘
                             │
                ┌────────────▼────────────┐
                │  Application Load       │
                │  Balancer (ALB)         │
                │  Port 80 → Target Group │
                └────────────┬────────────┘
                             │
    ┌────────────────────────┼────────────────────────┐
    │                        │                        │
    ▼                        ▼                        ▼
┌─────────┐            ┌─────────┐            ┌─────────┐
│  EC2-1  │            │  EC2-2  │            │  EC2-N  │
│ t3.micro│            │ t3.micro│   ........│ t3.micro│
│ (Auto   │            │ (Auto   │            │ (Auto   │
│ Scaling)│            │ Scaling)│            │ Scaling)│
└────┬────┘            └────┬────┘            └────┬────┘
     │                      │                      │
     ▼                      ▼                      ▼
  Docker              Docker                   Docker
  Nginx+React         Nginx+React              Nginx+React


┌────────────────────────────────────────────────────────┐
│              Terraform State Backend                    │
├────────────────────────────────────────────────────────┤
│  S3 Bucket: mystate002 ◄──── DynamoDB: mytable        │
│  - Versioning enabled        - State Locking           │
│  - Encryption enabled        - Prevents conflicts      │
│  - Region: us-east-1         - Concurrent safety      │
└────────────────────────────────────────────────────────┘


📁 Project Structure

DevOps Project/
├── terraform/                          # Infrastructure as Code
│   ├── main.tf                        # AWS backend config
│   ├── providers.tf                   # AWS provider setup
│   ├── variables.tf                   # Root variables
│   └── modules/
│       ├── VPC.tf                     # Network: VPC, subnets, IGW, routes
│       ├── Security-groups.tf         # Firewall rules (ingress/egress)
│       ├── IAM.tf                     # EC2 roles, permissions, policies
│       ├── LB.tf                      # ALB, target groups, listeners
│       ├── ASG.tf                     # Launch template, scaling policies
│       ├── userdata.tftpl             # EC2 bootstrap script
│       └── variables.tf               # Module variables
│
├── Dockerfile                          # Multi-stage build
│   ├── Stage 1: Node.js 18            # React app compilation
│   └── Stage 2: Nginx Alpine          # Production web server (~40MB)
│
├── src/                                # React application source
│   ├── components/                    # UI components (Header, Footer, etc.)
│   ├── assets/                        # Images, icons
│   ├── App.js                         # Main app component
│   └── index.js                       # Entry point
│
├── public/                             # Static files
│   ├── index.html
│   ├── manifest.json
│   └── robots.txt
│
├── package.json                        # Dependencies & scripts
├── terraform.tfstate                   # Remote state (S3 backend)
└── README.md                           # Documentation




