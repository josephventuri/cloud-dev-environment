# ⚙️ Cloud Dev Environment – AWS + Terraform

This project provisions a fully functional cloud-based development environment on AWS using Terraform. It automates the setup of secure networking, a Docker-ready EC2 instance, and local SSH access — all configured through Infrastructure as Code.

---

## 🚀 Why This Project Matters

Manually setting up development environments is time-consuming and error-prone. This project solves that by automating the entire process with Terraform. It’s reusable, scalable, and ideal for cloud engineers who want a reliable remote dev setup they can launch and connect to in minutes.

---

## 🛠️ Tech Stack

- **Terraform** – Infrastructure as Code
- **AWS EC2** – Cloud compute instance for development
- **VPC, Subnet, IGW, Route Table** – Custom networking setup
- **Security Group** – Controlled inbound/outbound traffic
- **SSH Key Pair + User Data** – Secure access and Docker bootstrapping
- **Local SSH Config Script** – Automatically updates your `~/.ssh/config` file

---

## 🧱 Architecture

- A public subnet inside a custom VPC
- Internet Gateway with outbound access
- EC2 instance launched with Docker installed via `userdata.tpl`
- Local machine updated with SSH connection config using a `templatefile` + `local-exec`



