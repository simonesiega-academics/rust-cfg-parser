# Docker Usage Guide

This guide explains everything needed to build, run, debug, and share this project with Docker, without installing Rust on the host machine.

---

## 1) What Docker files in this project do

### `Dockerfile`
Defines how to build the application image.

In this project, it uses a **multi-stage build**:
1. A Rust builder image compiles the binary in release mode.
2. A slim Debian runtime image contains only the final binary.

Result: smaller runtime image, no Rust toolchain needed by end users.

### `.dockerignore`
Lists files/folders excluded from the Docker build context (for faster and cleaner builds).

Current exclusions:
- `.git`
- `target`
- `docs`

### `docker-compose.yml`
Defines a runnable service (`mathsolver`) and its build configuration.

It simplifies local development by enabling one-command workflows with `docker compose` instead of manually using `docker build` + `docker run`.

---

## 2) Image Architecture

The Docker build uses a multi-stage approach:

- Stage 1: `rust:<version>` builder image compiles the binary in release mode.
- Stage 2: `debian:slim` runtime contains only the compiled binary and minimal system libraries.

This approach reduces image size and removes the Rust toolchain from the final image.

---

## 3) Prerequisites

- Docker Desktop installed
- Docker Desktop running
- Terminal opened in the project root directory.

Quick verification:

```bash
docker --version
docker info
```

If `docker info` fails, Docker daemon is not running.

---

## 4) Standard workflow (manual)

### Build image

```bash
docker build -t mathsolver .
```

- `-t mathsolver` gives the image a name/tag.
- `.` is mandatory: it is the build context path.

### Inspect image size

```bash
docker images mathsolver
```

- The multi-stage build keeps the runtime image minimal by excluding the Rust toolchain from the final stage.

### Run container

```bash
docker run --rm mathsolver
```

- Creates a container from `mathsolver` image.
- Executes the binary.
- `--rm` auto-removes the container after exit.

### Run without auto-removal (for inspection)

```bash
docker run --name mathsolver-test mathsolver
```

Then restart same container and attach output:

```bash
docker start -a mathsolver-test
```

Remove it when done:

```bash
docker rm mathsolver-test
```

---

## 5) One-command workflow with Compose

### First run / after code changes

```bash
docker compose up --build
```

### Run again without rebuild

```bash
docker compose up
```

### Stop and clean compose resources

```bash
docker compose down
```

### Rebuild from scratch if needed

```bash
docker compose build --no-cache
docker compose up
```

---

## 6) Understand image vs container

- **Image**: immutable template (built from `Dockerfile`).
- **Container**: runtime instance of an image.

`docker build` creates an image.

`docker run` creates and starts a container.

If you run with `--rm`, the container disappears after finishing. That is why you may not see it in Docker Desktop after execution.

---

## 7) Useful daily commands (copy/paste)

### List images

```bash
docker images
```

### List running containers

```bash
docker ps
```

### List all containers (running + exited)

```bash
docker ps -a
```

### Show logs of a container

```bash
docker logs <container_name_or_id>
```

### Remove one image

```bash
docker rmi mathsolver
```

### Remove all stopped containers

```bash
docker container prune
```

### Remove unused images, networks, cache

```bash
docker system prune
```

Aggressive cleanup including unused images:

```bash
docker system prune -a
```

---

## 8) Rebuild strategy after code updates

When Rust code changes, rebuild image:

```bash
docker build -t mathsolver .
docker run --rm mathsolver
```

or with compose:

```bash
docker compose up --build
```

---

## 9) Share with other users

You have two options.

### Option A: Share source code
Other users clone the repository and run:

```bash
docker build -t mathsolver .
docker run --rm mathsolver
```

### Option B: Publish prebuilt image (easiest for users)

Tag local image:

```bash
docker tag mathsolver <dockerhub-user>/mathsolver:latest
```

Push to registry:

```bash
docker push <dockerhub-user>/mathsolver:latest
```

Users run directly:

```bash
docker run --rm <dockerhub-user>/mathsolver:latest
```

You can also version tags:

```bash
docker tag mathsolver <dockerhub-user>/mathsolver:0.1.0
docker push <dockerhub-user>/mathsolver:0.1.0
```

---

## 10) Troubleshooting

### Error: `docker buildx build requires 1 argument`
Cause: missing build context path.

Fix:

```bash
docker build -t mathsolver .
```

### Error about `dockerDesktopLinuxEngine` / daemon not found
Cause: Docker Desktop engine is not running.

Fix:
1. Open Docker Desktop.
2. Wait for engine startup.
3. Retry command.

### Container not visible in Docker Desktop
If you used `--rm`, it is removed automatically after run.

To keep it visible:

```bash
docker run --name mathsolver-test mathsolver
```

### Port mapping questions
This project is a CLI binary, not a web server, so no `-p` mapping is needed.

---

## 11) Security and best practices

- Keep runtime image minimal (already done via multi-stage build).
- Do not run random images from untrusted sources.
- Prefer version tags over only `latest` for reproducibility.
- Rebuild images after dependency updates.
- Avoid committing secrets in repository files.
- Use specific base image versions instead of floating tags when possible.
- Regularly scan images for vulnerabilities.

---

## 12) Quick command cheat sheet

```bash
# Build
docker build -t mathsolver .

# Run once (auto remove container)
docker run --rm mathsolver

# Compose first run
docker compose up --build

# Compose run again
docker compose up

# Compose cleanup
docker compose down

# List images
docker images

# List containers
docker ps -a

# Remove named container
docker rm mathsolver-test

# Remove image
docker rmi mathsolver
```

---

## 13) When to Rebuild vs When to Re-run

- Re-run only: when no code or dependency changes occurred.
- Rebuild required: after modifying Rust source files, Cargo.toml, or Dockerfile.
- Full rebuild (`--no-cache`): when base images or dependencies change.