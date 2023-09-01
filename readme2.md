
---

# Purchasing and Activating and Installing SSL Certificates

To secure your application with HTTPS, you must have a valid domain name (e.g., www.yourdomain.com) and the ability to change its DNS records. If you meet these criteria, you can proceed with the following steps:
- If you already have ssl certificates(.crt and .key files) please feel free to skip first 2 steps
## 1. Purchase an SSL Certificate

1. Visit a domain hosting website (e.g., GoDaddy, Namecheap) and purchase an SSL certificate that matches your requirements (DV, EV, OV).

2. The process of purchasing the certificate is generally the same across providers, but the methods of activation may vary. In this guide, we'll focus on DV (Domain Validation) certificates.

## 2. Activating the SSL Certificate

Once you've purchased an SSL certificate, follow these steps to activate it:

- Locate your SSL certificates section on your hosting provider's platform.

- Select the certificate you want to activate, and you should find an "Activate" option.

- During the activation process, you'll encounter several steps.

### Certificate Signing Request (CSR)

In this step, you'll need to provide the following:

- The domain name for which you intend to use the SSL certificate.
- A CSR file in text format.

#### Generating a CSR File

You can generate a CSR file on a Linux machine using the following command:

```bash
openssl req -new -newkey rsa:2048 -nodes -keyout yourdomain.key -out yourdomain.csr
```

Replace `yourdomain.key` and `yourdomain.csr` with your desired filenames.

You'll be prompted to answer several questions:

1. Country Name (2 letter code): Enter the two-letter code for your country (e.g., "US" for the United States).
2. State or Province Name: Provide the name of your state or province.
3. Locality Name (e.g., city): Specify your city or locality.
4. Organization Name (e.g., company): Enter your organization's legal name.
5. Organizational Unit Name (e.g., section): Optionally, provide the name of your department within the organization.
6. Common Name (e.g., server FQDN or YOUR name): This is the fully qualified domain name (FQDN) of your server (e.g., "www.example.com"). It's a critical field as it identifies the domain for which you're requesting the certificate.
7. Email Address: Optionally, enter your email address.
8. A challenge password: You can leave this empty unless you specifically require a challenge password.
9. An optional company name: You can leave this empty unless your organization has a specific name.

After completing this process, you'll have two files: `yourdomain.csr` and `yourdomain.key`. Safeguard `yourdomain.key` for future use.

Copy the contents of `yourdomain.csr` and paste them into the CSR registration section of your SSL certificate provider.

Once the CSR and the submitted domain name are validated, the SSL certificate activation process begins, and the status is set to "Pending" because you need to verify that you own the submitted domain name.

### Domain Name Validation

After CSR registration and when the certificate status is set to "Pending," you'll receive a CNAME (Canonical Name) record with two fields: Name and Value. Copy these values and go to the website where you purchased your domain name.

Navigate to the DNS management section and select "Edit DNS records." Create a new DNS record of type "CNAME" with the Name field set to the record's name and the Value field set to the record's value.

Note: DNS changes may take a few minutes or up to an hour to propagate. Once propagated, your SSL certificate will be automatically activated.

Once activated, make sure to download the .crt certificate. This certificate is your SSL certificate, and you'll need to install it.

**Note**: Remove your domain name from the end of the CNAME Name field. For example, if your CNAME Name looks like "_5a97e9d61040dae8e6f5bdf49ff24e80.yourdomain.in," remove ".yourdomain.in."

Here is the improved and properly formatted installation guide for SSL certificates on an Nginx container:

---

## 3. Installing SSL Certificates

Your .crt and .key files together constitute SSL certificates, and these certificates must be installed on your Nginx, load balancers, or Apache servers to serve applications over HTTPS. Here are the steps to install them on our Nginx container, which we use to load balance multiple Streamlit apps. Make sure to follow these steps carefully:
- Generally .crt and .key files by themselves are sufficient for installation but some servers may require some additional steps , even after following these steps you will ultimately end with the same 2 files .crt and .key
- If you are not sure whether the .crt generated and .key are not related , you can easily verify them online or by using openssl commands on linux
1. **Update Docker Compose Configuration**:

   - Inside the `ssl` folder, you will find updated `docker-compose.yml` and `nginx.conf` files. Replace the original `docker-compose.yml` and `nginx.conf` files located outside the `ssl` folder with these updated versions.

   **docker-compose.yml:**

   ```yaml
   nginx:
     image: nginx:latest
     volumes:
       - ./nginx.conf:/etc/nginx/nginx.conf # Mount nginx.conf file
       - ./ssl/yourdomain.crt:/etc/nginx/ssl/yourdomain.crt    # Mount the SSL certificates
       - ./ssl/yourdomain.key:/etc/nginx/ssl/yourdomain.key
     ports:
       - "443:443"
     networks:
       - backend
     depends_on:
       - streamlit_app_1
       - streamlit_app_2
       - streamlit_app_3
   ```

2. **Update Nginx Configuration**:

   - Make changes to the Nginx configuration in the updated `nginx.conf` file.

   **nginx.conf:**

   ```nginx
   server {
       listen 443 ssl;
       server_name www.yourdomain.com;  # Replace with your domain

       ssl_certificate /etc/nginx/ssl/yourdomain.crt;       # Path to your SSL certificate
       ssl_certificate_key /etc/nginx/ssl/yourdomain.key;   # Path to your private key

       ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
       ssl_ciphers         HIGH:!aNULL:!MD5;

       index index.php index.html index.htm;
       location / {
       .....
   ```

3. **Run Docker Compose**:

   After replacing the `docker-compose.yml` and `nginx.conf` files, execute the following command to start your container:

   ```bash
   docker-compose up
   ```

4. **Update DNS Records Again**:

   After running `docker-compose up`, you can access your application at `https://ipv4_addr`, but the website will be shown as insecure. To resolve this, you need to update the DNS records of your website to point to the IPv4 address of your instance.

   - Navigate to the DNS records of the website where your domain is hosted.

   - Locate the DNS record of type "A" (Address) whose value is set to "Parked." Replace "Parked" with the IPv4 address of your instance.

   Until you complete this step, your website won't be served over HTTPS.

5. **Access Your Application Over HTTPS**:

   Once you have completed the DNS record update, you can access your application at `www.yourdomain.com`, and it will be served securely over HTTPS.

---

Following these steps will ensure that your SSL certificates are correctly installed on your Nginx container, and your application will be accessible over HTTPS with the added security and encryption.
