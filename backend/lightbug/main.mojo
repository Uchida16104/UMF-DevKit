from python import Python
from sys import argv

fn get_port() -> Int:
    try:
        env = Python.import_module("os")
        port_str = env.environ.get("PORT", "8008")
        return int(port_str.__str__())
    except:
        return 8008

fn main() raises:
    let socket_module = Python.import_module("socket")
    let json_module = Python.import_module("json")

    let port = get_port()
    let host = "0.0.0.0"

    let server_socket = socket_module.socket(
        socket_module.AF_INET,
        socket_module.SOCK_STREAM
    )
    server_socket.setsockopt(
        socket_module.SOL_SOCKET,
        socket_module.SO_REUSEADDR,
        1
    )
    server_socket.bind((host, port))
    server_socket.listen(128)

    print("Lightbug (Mojo) listening on port", port)

    while True:
        let conn_addr = server_socket.accept()
        let conn = conn_addr[0]

        try:
            let data = conn.recv(4096)
            let request = str(data.decode("utf-8", errors="replace"))

            let path = extract_path(request)

            let body: String
            if path == "/health":
                body = '{"status":"ok","service":"umf-lightbug","version":"1.0.0"}'
            elif path == "/hello":
                body = '{"message":"Hello from Lightbug (Mojo)!","framework":"Lightbug","language":"Mojo"}'
            else:
                body = '{"message":"UMF-DevKit Lightbug service is running.","framework":"Lightbug","language":"Mojo"}'

            let response = (
                "HTTP/1.1 200 OK\r\n"
                + "Content-Type: application/json\r\n"
                + "Content-Length: " + str(len(body)) + "\r\n"
                + "Access-Control-Allow-Origin: *\r\n"
                + "Connection: close\r\n"
                + "\r\n"
                + body
            )
            _ = conn.sendall(response.encode("utf-8"))
        except:
            pass
        finally:
            conn.close()

fn extract_path(request: String) -> String:
    let lines = request.split("\r\n")
    if len(lines) == 0:
        return "/"
    let parts = lines[0].split(" ")
    if len(parts) < 2:
        return "/"
    return parts[1]
