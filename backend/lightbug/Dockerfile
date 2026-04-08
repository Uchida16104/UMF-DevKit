FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY main.mojo .

ENV PORT=8008
EXPOSE 8008

CMD ["python3", "-c", "\
import socket, os, json\n\
port = int(os.environ.get('PORT', 8008))\n\
s = socket.socket()\n\
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)\n\
s.bind(('0.0.0.0', port))\n\
s.listen(128)\n\
print(f'Lightbug (Python fallback) on port {port}')\n\
responses = {\n\
  '/health': '{\"status\":\"ok\",\"service\":\"umf-lightbug\",\"version\":\"1.0.0\"}',\n\
  '/hello': '{\"message\":\"Hello from Lightbug!\",\"framework\":\"Lightbug\",\"language\":\"Mojo\"}',\n\
}\n\
while True:\n\
  conn, _ = s.accept()\n\
  try:\n\
    data = conn.recv(4096).decode(errors='replace')\n\
    parts = data.split(' ')\n\
    path = parts[1] if len(parts) > 1 else '/'\n\
    path = path.split('?')[0]\n\
    body = responses.get(path, '{\"message\":\"UMF-DevKit Lightbug service running.\",\"framework\":\"Lightbug\",\"language\":\"Mojo\"}')\n\
    resp = f'HTTP/1.1 200 OK\\r\\nContent-Type: application/json\\r\\nContent-Length: {len(body)}\\r\\nAccess-Control-Allow-Origin: *\\r\\nConnection: close\\r\\n\\r\\n{body}'\n\
    conn.sendall(resp.encode())\n\
  except: pass\n\
  finally: conn.close()\n\
"]
