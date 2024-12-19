# Get Server Info

A lightweight system information tool that provides details such as:
- **Private IP Address**
- **Public IP Address**
- **CPU Architecture**
- **Number of CPU Cores**
- **Total Memory (RAM)**
- **Disk Space**

The app runs as a web server, making this information available through a simple HTTP API.

---

## Features

- Provides system information via an HTTP endpoint (`/info`).
- Automatically starts on server boot using `systemd`.
- Restarts if the application crashes.
## Installation

Install and configure the app with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/cameronjweeks/get_server_info/main/install.sh | bash
```

### What this command does:
 1.) Downloads the install script
 2.) Downloads the application
 3.) installs the app to /usr/local/bin
 4.) sets up a systemd service to run the app

 ## Usage
 After installation, the app will run automatically. You can access it via 127.0.0.1 on port 8080.

 ```bash
 curl http://<server-ip>:8080/info
 ```

 ### Example Response 
 ```bash
 {
  "hostname": "my-server",
  "local_ip": "192.168.1.100",
  "public_ip": "203.0.113.5",
  "cpu_architecture": "x86_64",
  "cpu_cores": 4,
  "cpu_threads": 8,
  "memory_gb": 16,
  "disk_space_gb": 256
}
```