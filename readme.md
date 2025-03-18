# AWS Site-to-Site VPN with Terraform

This project demonstrates how to set up an AWS Site-to-Site VPN using Terraform to securely connect an on-premises network to AWS cloud resources. The configuration creates a VPN tunnel between two AWS regions (Mumbai and N. Virginia) as a simulation of an on-premises-to-cloud connection.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Setup Instructions](#setup-instructions)
- [File Structure](#file-structure)
- [Cleanup](#cleanup)
- [Conclusion](#conclusion)

## Overview

This guide uses Terraform, an Infrastructure as Code (IaC) tool, to provision:

- A Virtual Private Cloud (VPC) in Mumbai (ap-south-1) and N. Virginia (us-east-1) regions.
- An AWS Site-to-Site VPN connecting the two VPCs.
- An EC2 instance in N. Virginia simulating an on-premises network with Libreswan for IPsec configuration.

The VPN ensures encrypted data transfer between networks, providing a secure and scalable solution.

## Prerequisites

- **AWS Account**: Active account with permissions to create VPCs, VPNs, and EC2 instances.
- **Terraform**: Installed locally (version 5.43.0 or compatible).
- **Tools**: Visual Studio Code (or any text editor), MobaXterm/PuTTY for SSH.
- **AWS CLI**: Configured with a `default` profile (optional for Terraform profile usage).

## Architecture

The setup includes:

- **Mumbai Region (ap-south-1)**: VPC, Virtual Private Gateway (VPG), Site-to-Site VPN.
- **N. Virginia Region (us-east-1)**: VPC, EC2 instance (simulating on-premises), Customer Gateway (CGW).
- **VPN Connection**: IPsec tunnel between Mumbai and N. Virginia.

## Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone https://github.com/Navneet072300/site-to-site-vpn
   ```

2. **Configure Terraform for N. Virginia (us-east-1)**

   - Edit `provider.tf` and `vpc.tf` for N. Virginia.
   - Deploy EC2 instance with `ec2.tf`.
   - Run:
     ```bash
     terraform init
     terraform plan
     terraform apply
     ```
   - Note the EC2 public IP for the next steps.

3. **Configure Terraform for Mumbai (ap-south-1)**

   - Edit `provider.tf`, `vpc.tf`, and `vpn.tf`.
   - Update `vpn.tf` with the EC2 public IP from N. Virginia.
   - Run:
     ```bash
     terraform init
     terraform plan
     terraform apply -auto-approve
     ```

4. **Set Up EC2 Instance (N. Virginia)**

   - SSH into the EC2 instance using MobaXterm/PuTTY.
   - Install Libreswan and configure IPsec:
     ```bash
     sudo su
     yum install libreswan -y
     vi /etc/ipsec.conf  # Add "include /etc/ipsec.d/*.conf"
     vi /etc/sysctl.conf  # Enable IP forwarding
     systemctl restart systemd-networkd
     ```
   - Create `/etc/ipsec.d/aws-vpn.conf` and `/etc/ipsec.d/aws-vpn.secrets` with VPN details from AWS Console.
   - Start IPsec:
     ```bash
     chkconfig ipsec on
     service ipsec start
     service ipsec status
     ```

5. **Verify VPN Connection**
   - Check the AWS Console (VPN Connections) for tunnel status.

## File Structure

```
.
├── provider.tf    # AWS provider configuration (region-specific)
├── vpc.tf         # VPC, subnets, gateways, and routes
├── ec2.tf         # EC2 instance and security groups (N. Virginia)
├── vpn.tf         # VPN gateway, customer gateway, and VPN connection (Mumbai)
└── README.md      # Project documentation
```

## Cleanup

To delete all resources:

- In both regions, run:

  ```bash
  terraform destroy -auto-approve
  ```

  ![alt text](<Screenshot 2025-03-18 at 11.45.04 AM.png>)
  ![alt text](<Screenshot 2025-03-18 at 11.53.34 AM.png>)
  ![alt text](<Screenshot 2025-03-18 at 11.53.43 AM.png>)
  ![alt text](<Screenshot 2025-03-18 at 11.54.21 AM.png>)
  ![alt text](<Screenshot 2025-03-18 at 12.04.03 PM.png>)
  ![alt text](<Screenshot 2025-03-18 at 12.07.31 PM.png>)
  ![alt text](<Screenshot 2025-03-18 at 12.08.03 PM.png>)

## Conclusion

This project showcases how Terraform simplifies the setup of an AWS Site-to-Site VPN, enabling secure connectivity between on-premises and cloud environments. The configuration is modular, reusable, and scalable for production use.
