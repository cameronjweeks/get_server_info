from flask import Flask, jsonify
import socket
import requests
import psutil
import platform

app = Flask(__name__)

@app.route('/info', methods=['GET'])
def system_info():
    try:
        # Retrieve the private IP
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
    except Exception as e:
        local_ip = f"Error retrieving local IP: {e}"

    try:
        # Retrieve the public IP
        public_ip = requests.get("http://checkip.amazonaws.com").text.strip()
    except Exception as e:
        public_ip = f"Error retrieving public IP: {e}"

    # Retrieve CPU and system information
    cpu_arch = platform.machine()
    cpu_cores = psutil.cpu_count(logical=False)
    cpu_threads = psutil.cpu_count(logical=True)

    # Retrieve memory and disk information
    memory = psutil.virtual_memory().total // (1024 ** 3)  # Convert to GB
    disk = psutil.disk_usage('/').total // (1024 ** 3)  # Convert to GB

    return jsonify({
        "hostname": socket.gethostname(),
        "local_ip": local_ip,
        "public_ip": public_ip,
        "cpu_architecture": cpu_arch,
        "cpu_cores": cpu_cores,
        "cpu_threads": cpu_threads,
        "memory_gb": memory,
        "disk_space_gb": disk
    })

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080)