from flask import Flask, jsonify
import socket
import requests
import argparse
import os

app = Flask(__name__)

@app.route('/info', methods=['GET'])
def system_info():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
    except Exception as e:
        local_ip = f"Error retrieving local IP: {e}"

    try:
        public_ip = requests.get("http://checkip.amazonaws.com").text.strip()
    except Exception as e:
        public_ip = f"Error retrieving public IP: {e}"

    return jsonify({
        "hostname": socket.gethostname(),
        "local_ip": local_ip,
        "public_ip": public_ip
    })

if __name__ == '__main__':
    # Parse command-line arguments or use environment variables
    parser = argparse.ArgumentParser(description='Run the server info app.')
    parser.add_argument('--host', default=os.getenv('APP_HOST', '0.0.0.0'), help='IP address to bind to (default: 0.0.0.0)')
    parser.add_argument('--port', default=int(os.getenv('APP_PORT', 82)), type=int, help='Port to listen on (default: 82)')
    args = parser.parse_args()

    app.run(host=args.host, port=args.port)