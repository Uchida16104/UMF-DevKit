# UMF-DevKit — Unified Multi-Framework Developer Kit

A production-ready GitHub template repository providing a polyglot, mono-repo scaffold that combines every major frontend, backend, verification, creative, and infrastructure technology into a single cloneable starting point.

---

## Technology Stack

**Frontend:** HTMX · hyperscript · Tailwind CSS · Vue.js 3  
**Backend:** Laravel (PHP) · Actix-web (Rust) · ASP.NET Core (C#) · FastAPI + Uvicorn (Python 3) · Drogon (C++) · Jetzig (Zig) · Zylix (Zig) · Lightbug (Mojo)  
**Verification / Specification:** Dafny · F*  
**Creative Coding:** Processing (Java)  
**Documentation:** Mermaid (architecture, flowcharts, sequence, algorithm diagrams)  
**Infrastructure:** Docker · Docker Compose · PostgreSQL  
**Deployment:** Vercel (frontend) · Render (backend services)

---

## Directory and File Structure

```
UMF-DevKit/
├── README.md
├── .gitignore
├── docker-compose.yml
├── vercel.json
├── render.yaml
│
├── frontend/
│   ├── htmx/
│   │   └── index.html              # HTMX + hyperscript demo page
│   ├── vue/
│   │   ├── index.html
│   │   ├── package.json
│   │   ├── vite.config.js
│   │   └── src/
│   │       ├── main.js
│   │       ├── App.vue
│   │       └── components/
│   │           └── HelloWorld.vue
│   └── tailwind/
│       ├── tailwind.config.js
│       └── postcss.config.js
│
├── backend/
│   ├── laravel/
│   │   ├── Dockerfile
│   │   └── README.md               # Laravel scaffold instructions
│   ├── actix/
│   │   ├── Dockerfile
│   │   ├── Cargo.toml
│   │   └── src/
│   │       └── main.rs
│   ├── aspnet/
│   │   ├── Dockerfile
│   │   ├── aspnet.csproj
│   │   └── Program.cs
│   ├── fastapi/
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── main.py
│   ├── drogon/
│   │   ├── Dockerfile
│   │   ├── CMakeLists.txt
│   │   └── main.cc
│   ├── jetzig/
│   │   ├── Dockerfile
│   │   ├── build.zig
│   │   └── src/
│   │       └── main.zig
│   ├── zylix/
│   │   ├── Dockerfile
│   │   ├── build.zig
│   │   └── src/
│   │       └── main.zig
│   └── lightbug/
│       ├── Dockerfile
│       └── main.mojo
│
├── creative/
│   └── processing/
│       └── sketch/
│           └── sketch.pde
│
├── verification/
│   ├── dafny/
│   │   └── example.dfy
│   └── fstar/
│       └── example.fst
│
├── docs/
│   └── diagrams/
│       ├── architecture.md
│       ├── flowchart.md
│       ├── sequence.md
│       └── algorithm.md
│
└── infra/
    └── postgres/
        └── init.sql
```

---

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/UMF-DevKit.git
cd UMF-DevKit
docker compose up --build
```

This single command starts all backend services and PostgreSQL together via Docker Compose. Each service runs in its own container on a dedicated port.

---

## Service Port Map

| Service        | Technology       | Port  |
|----------------|-----------------|-------|
| HTMX Frontend  | Static / Nginx   | 8080  |
| Vue Frontend   | Vite Dev Server  | 5173  |
| Laravel        | PHP-FPM / Nginx  | 8001  |
| Actix-web      | Rust             | 8002  |
| ASP.NET Core   | C#               | 8003  |
| FastAPI        | Python / Uvicorn | 8004  |
| Drogon         | C++              | 8005  |
| Jetzig         | Zig              | 8006  |
| Zylix          | Zig              | 8007  |
| Lightbug       | Mojo             | 8008  |
| PostgreSQL     | Postgres 16      | 5432  |

---

## Per-Framework Development Workflow

### Frontend — HTMX + hyperscript

No build step is required. Open `frontend/htmx/index.html` directly in a browser, or serve it with any static server:

```bash
npx serve frontend/htmx
```

HTMX is loaded from CDN. hyperscript is loaded from CDN. Tailwind CSS is loaded via the CDN play script for rapid prototyping.

### Frontend — Vue.js 3

```bash
cd frontend/vue
npm install
npm run dev
```

The dev server starts at `http://localhost:5173`. To create a fresh project with the official scaffolding tool run `npm create vue@latest` and follow the prompts.

### Frontend — Tailwind CSS

Tailwind configuration lives in `frontend/tailwind/`. To compile Tailwind for a specific sub-project:

```bash
cd frontend/tailwind
npx tailwindcss -i ./input.css -o ./output.css --watch
```

### Backend — Laravel (PHP / Blade)

Laravel requires an existing Composer installation. Initialize a fresh application:

```bash
cd backend/laravel
composer create-project laravel/laravel sample
cd sample
php artisan serve
```

The Dockerfile in `backend/laravel/` builds a production-ready container. See `backend/laravel/README.md` for environment variable setup.

### Backend — Actix-web (Rust)

```bash
cd backend/actix
cargo run
```

Requires Rust stable toolchain (`rustup install stable`). The server starts at `http://localhost:8002`.

### Backend — ASP.NET Core (C#)

```bash
cd backend/aspnet
dotnet run
```

Requires .NET 8 SDK. The server starts at `http://localhost:8003`.

### Backend — FastAPI (Python 3)

```bash
cd backend/fastapi
pip install -r requirements.txt
uvicorn main:app --reload --port 8004
```

Interactive API docs are available at `http://localhost:8004/docs`.

### Backend — Drogon (C++)

```bash
cd backend/drogon
mkdir build && cd build
cmake .. && make -j$(nproc)
./drogon_app
```

Requires Drogon framework and CMake 3.16+. The server starts at `http://localhost:8005`.

### Backend — Jetzig (Zig)

```bash
cd backend/jetzig
zig build run
```

Requires Zig 0.13+. The server starts at `http://localhost:8006`.

### Backend — Zylix (Zig)

```bash
cd backend/zylix
zig build run
```

Requires Zig 0.13+. The server starts at `http://localhost:8007`.

### Backend — Lightbug (Mojo)

```bash
cd backend/lightbug
mojo main.mojo
```

Requires Mojo SDK. The server starts at `http://localhost:8008`.

### Creative Coding — Processing (Java)

Open `creative/processing/sketch/sketch.pde` in the Processing IDE (https://processing.org/download) and click Run.

### Verification — Dafny

```bash
cd verification/dafny
dafny verify example.dfy
```

Requires Dafny CLI (`dotnet tool install --global Dafny`).

### Verification — F*

```bash
cd verification/fstar
fstar.exe example.fst
```

Requires F* installation from https://fstar-lang.org.

---

## Deployment

### Vercel (Frontend)

The `vercel.json` in the repository root configures the Vue.js frontend build for Vercel. Push the repository to GitHub, then in the Vercel dashboard:

1. Import the repository.
2. Set the Root Directory to `frontend/vue`.
3. Framework preset: Vite.
4. Click Deploy.

The HTMX page in `frontend/htmx/` can be deployed as a separate Vercel project with the Root Directory set to `frontend/htmx` and no build command.

### Render (Backend Services)

The `render.yaml` declares all backend services. In the Render dashboard:

1. Click **New → Blueprint**.
2. Connect the GitHub repository.
3. Render reads `render.yaml` and provisions all services automatically.
4. Set the required environment variables (DATABASE_URL, APP_KEY, etc.) in the Render dashboard under each service's **Environment** tab.

Each service builds from its own Dockerfile located in its respective `backend/<name>/` directory.

---

## Mermaid Diagrams

All diagrams live in `docs/diagrams/`. Each `.md` file contains fenced Mermaid code blocks that render natively in GitHub, GitLab, and most Markdown previewers.

| File                          | Contents                                      |
|-------------------------------|-----------------------------------------------|
| `docs/diagrams/architecture.md` | System architecture — all services overview |
| `docs/diagrams/flowchart.md`    | Request routing flowchart                   |
| `docs/diagrams/sequence.md`     | Service-to-service sequence diagram         |
| `docs/diagrams/algorithm.md`    | Algorithm examples (Fibonacci, sort)        |

---

## Environment Variables

Copy `.env.example` values into your deployment environment. The minimum required variables are:

```
DATABASE_URL=postgresql://umfuser:umfpassword@postgres:5432/umfdb
APP_KEY=base64:CHANGE_ME_LARAVEL_KEY
SECRET_KEY=CHANGE_ME_FASTAPI_SECRET
ASPNETCORE_ENVIRONMENT=Production
```

---

## Initialization References

| Framework | Command                                          |
|-----------|--------------------------------------------------|
| Laravel   | `composer create-project laravel/laravel sample` |
| Vue.js    | `npm create vue@latest`                          |
| Actix     | `cargo new actix-app`                            |
| ASP.NET   | `dotnet new webapi -n aspnet-app`                |
| FastAPI   | `pip install fastapi uvicorn`                    |
| Drogon    | `drogon_ctl create project drogon-app`           |
| Jetzig    | `jetzig init jetzig-app`                         |

---

## License

MIT — see `LICENSE` file.
