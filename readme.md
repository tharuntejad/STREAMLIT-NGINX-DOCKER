# Deploying a Streamlit Application with Docker Containers and Nginx Load Balancing on EC2

*Introduction:*

Modern application deployment techniques have revolutionized the way we bring software to life. In this guide, we'll explore a powerful deployment strategy that combines the flexibility of Docker containers with the efficiency of Nginx load balancing on an EC2 instance. By the end of this article, you'll be well-equipped to launch your Streamlit application with confidence, ensuring reliability and scalability.

---

## Section 1: Configuring EC2 for Docker Deployment

### SSH into the EC2 Instance

1. Open your terminal.
2. Establish an SSH connection to your EC2 instance:

```bash
ssh -i /path/to/your/keyfile.pem ubuntu@your_ec2_public_ip
```

### Updating Ubuntu

3. Begin by updating the package list and upgrading existing packages:

```bash
sudo apt update
sudo apt upgrade -y
```

### Installing Docker Engine

The following steps will guide you through setting up the Docker engine and Docker Compose on your Ubuntu server. You can also find these steps in Docker's official documentation [here](https://docs.docker.com/engine/install/ubuntu/).

4. Remove any conflicting packages:

```bash
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

5. Update the apt package index and install necessary packages for accessing repositories over HTTPS:

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
```

6. Add Docker's official GPG key:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

7. Set up the Docker repository:

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

8. Update the apt package index:

```bash
sudo apt-get update
```

9. Install Docker and Docker Compose:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

10. Confirm the successful installation of Docker Engine by running the hello-world image:

```bash
sudo docker run hello-world
```

## Section 2: Moving Code to the Remote Server

### Using FileZilla (Windows)

1. Download and install FileZilla.
2. Launch FileZilla and input your EC2 instance details (hostname, username, and keyfile).
3. Connect to the EC2 instance and navigate to the desired transfer directory.
4. Drag and drop your project folder into the remote directory.

### Using SFTP (Linux/MacOS)

1. Open your terminal.
2. Connect to your EC2 instance using the `sftp` command:

```bash
sftp -i /path/to/your/keyfile.pem ubuntu@your_ec2_public_ip
```

3. Navigate to the remote directory:

```bash
cd /path/to/remote/directory
```

4. Upload your project folder using the `put` command:

```bash
put -r /path/to/your/local/project
```

(Note: If you encounter file access issues during transfer, ensure the appropriate permissions by running the below commands)
```bash
sudo chown ubuntu: /home/ubuntu/path_to_project
sudo chmod u+w /home/ubuntu/path_to_project

```

---

## Section 3: Building Docker Image

### Building the Docker Image

1. SSH into your EC2 instance as previously demonstrated.
2. Navigate to your project directory:

```bash
cd /path/to/your/project
```

3. Build the Docker image using the provided Dockerfile:

```bash
docker build -t your_app_image_name .
```

## Section 4: Running Docker Compose

### Creating `docker-compose.yml`

1. Create a `docker-compose.yml` file in your project directory.
2. Copy the contents of the provided `docker-compose.yml` into this file.

### Creating an `nginx.conf` 

1. Create an `nginx.conf` file in your project directory (adjacent to docker-compose.yml).
2. Copy the contents of the provided `nginx.conf` into this file.

### Running Docker Compose

1. SSH into your EC2 instance.
2. Navigate to your project directory:

```bash
cd /path/to/your/project
```

3. Run the Docker Compose command:

```bash
docker-compose up -d
```

## Section 5: Viewing the Application

### Modifying Inbound Security Rules of the Instance

To view our application, we need to open a TCP port (port 80 in our case) in our instance's firewall:

1. Navigate to the instance's `Security Group Settings`.
2. Add an inbound rule of type TCP over port 80 and select the CIDR range to provide access to (typically '0.0.0.0/0').

### Viewing Our App

Once the inbound rules of our instance have been adjusted, you can directly access the app using the URL: `http://instance_public_ipv4`.

---

By following this comprehensive guide, you've learned how to set up an EC2 instance, transfer your code, create Docker images, and deploy your Streamlit application using Docker containers and Nginx load balancing. Make sure to replace placeholders with actual values relevant to your setup, and ensure proper permissions and security configurations are in place for your EC2 instance. This deployment technique offers isolation, scalability, and portability, streamlining your application deployment process.

--- 
Notes:
- If you're using PowerShell 7 or above, you can take advantage of SSH and SFTP directly in your terminal,
  eliminating the need for external tools like FileZilla(for SFTP) or Putty(for SSH).
- 

---
