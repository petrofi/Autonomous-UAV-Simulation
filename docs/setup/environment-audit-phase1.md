# Phase 1 Development Environment Audit

## Audit Metadata

- **Audit date:** 2026-07-16
- **Scope:** Read-only inspection before dependency installation
- **Distribution:** Ubuntu 24.04.3 LTS (`noble`) on WSL2
- **Repository:** `/home/darklove/projects/autonomous-uav-simulation`
- **Branch:** `main`
- **Baseline:** `9c00df8 chore: add Phase 0 repository scaffolding`
- **Remote:** `https://github.com/petrofi/Autonomous-UAV-Simulation.git`

No package installation, upgrade, repository addition, `sudo` command, upstream
clone, shell configuration change, firewall change, container operation,
commit, or push was performed during this audit.

## Readiness Summary

At audit time, the WSL2, Linux filesystem, systemd, WSLg, hardware, GPU
visibility, time synchronization, DNS, HTTPS, and GitHub-read foundations were
available, but the simulation stack and required build tools were not installed.
The Phase 1A and Phase 1B records supersede this point-in-time readiness result.

## Step 1 — Repository Context

| Check | Result |
| --- | --- |
| Working directory and Git top level | `/home/darklove/projects/autonomous-uav-simulation` |
| Filesystem | Linux `ext4` on `/dev/sdd` |
| Branch | `main` |
| Upstream state | `HEAD`, `origin/main`, and `origin/HEAD` at `9c00df8` |
| Initial worktree | Clean |

The Linux checkout is the required development copy. A separate Windows-host
checkout exists outside the Linux filesystem and must not be used for WSL builds.

## Step 2 — Ubuntu, Kernel, and WSL2

| Item | Observed value |
| --- | --- |
| Ubuntu | 24.04.3 LTS (Noble Numbat) |
| Architecture | `amd64` / `x86_64` |
| WSL package | 2.6.3.0 |
| Default distribution / version | `Ubuntu-24.04` / WSL2 |
| WSL kernel reported by Windows | 6.6.87.2-1 |
| Kernel inside Ubuntu | `6.6.87.2-microsoft-standard-WSL2` |
| WSLg | 1.0.71 |
| Windows build reported by WSL | 10.0.26200.8875 |

The stopped distribution became running when inspection commands were executed.

## Step 3 — systemd

| Check | Result |
| --- | --- |
| PID 1 | `systemd` |
| Version / state | 255 / `running` |
| Failed units | None reported |

`loginctl show-session self` was unavailable because the non-interactive WSL
caller was not a registered logind session. This is not a systemd failure.

## Step 4 — WSLg and Display Environment

| Item | Observed value |
| --- | --- |
| `DISPLAY` / `WAYLAND_DISPLAY` | `:0` / `wayland-0` |
| `PULSE_SERVER` | `unix:/mnt/wslg/PulseServer` |
| `XDG_RUNTIME_DIR` | `/run/user/1000/` |
| WSLg and X11 | `/mnt/wslg` and `/tmp/.X11-unix/X0` present |
| GPU bridge | `/dev/dxg` present; `/dev/dri` absent |

WSLg transport is present. End-to-end OpenGL and Vulkan rendering was not run
because `glxinfo` and `vulkaninfo` are unavailable.

## Step 5 — CPU, Memory, Storage, and GPU

| Resource | Observed value |
| --- | --- |
| CPU | 12th Gen Intel Core i7-12700H; 20 logical CPUs |
| Memory / swap | 16,237,736 kB / 4,194,304 kB |
| Linux root filesystem | 1007 GiB total; 922 GiB available; 4% used |
| GPU | NVIDIA GeForce RTX 4060 Laptop GPU; 8188 MiB |
| NVIDIA driver | 595.97 |
| Driver-reported CUDA capability | 13.2 |

`nvidia-smi` works through WSL. The CUDA value is driver capability and does
not prove that a CUDA toolkit is installed. `lspci` is unavailable, but
`/dev/dxg` and `nvidia-smi` provide GPU visibility.

## Step 6 — Development Tools

### Available

| Tool | Version or evidence |
| --- | --- |
| Git / curl / wget | 2.43.0 / 8.5.0 / 1.21.4 |
| OpenSSH client | 9.6p1 |
| Python / pip | 3.12.3 / 24.0 |
| Python venv and headers | Available for Python 3.12 |
| GNU Make / GCC / G++ | 4.3 / 13.3.0 / 13.3.0 |
| build-essential | 12.10ubuntu1 |
| rsync / GNU tar | 3.2.7 / 1.35 |
| Locale | `C.UTF-8` |

### Unavailable

- CMake, Ninja, Clang, Clang++, GDB command, ccache, pkg-config, and genromfs
- colcon, Java, Node.js, Docker CLI, Git LFS, and jq
- zip, unzip, lspci, glxinfo, and vulkaninfo

Docker Desktop has a separate stopped WSL distribution, but Docker integration
is not enabled in `Ubuntu-24.04`. No container was started or created.

## Step 7 — Existing Project Components

| Component | Inspection result |
| --- | --- |
| PX4 / PX4-Autopilot | No command, package, or checkout detected |
| Gazebo Harmonic | No `gz` command or matching packages detected |
| Ignition / Gazebo Classic | No `ign` or `gazebo` command detected |
| ROS 2 Jazzy | No CLI, environment, `/opt/ros`, or Jazzy packages detected |
| MAVSDK / pymavlink | No Python or system package detected |
| QGroundControl | No Linux command, AppImage, or home installation detected |

`mission_client/mavsdk` is a documentation placeholder, not an installation.
The home scan could not traverse `/home/darklove/darklove-linux/venv` due to
permissions; command, package, Python-package, and standard-path checks still
found no project component installations.

## Step 8 — Network and GitHub Access

| Check | Result |
| --- | --- |
| WSL DNS / default route | `10.255.255.254` / `172.25.160.1` |
| GitHub DNS | Resolved to `140.82.121.4` during the audit |
| GitHub and API HTTPS | HTTP 200 |
| ICMP to GitHub | Successful; approximately 83 ms for one sample |
| Git remote read | Successful |
| Remote `main` | `9c00df89f37275ccc90f3cf6a41ef5b0aa294538` |
| Proxy configuration | No environment or Git proxy detected |

The GitHub check was read-only. No fetch, commit, or push was performed.

## Step 9 — Conflicts, Risks, and Blockers

### Blocking the First Smoke Test

1. PX4-Autopilot is not present.
2. Gazebo Harmonic is not installed.
3. CMake, Ninja, pkg-config, ccache, genromfs, and expected helpers are absent.
4. Compatible PX4 and Python selections remain unresolved in
   `toolchain/versions.yaml`.

### Deferred Components and Checks

- ROS 2, MAVSDK, and QGroundControl are not installed, but are not required for
  the first headless PX4 SITL and Gazebo smoke test.
- OpenGL and Vulkan rendering have not been validated; this remains a
  prerequisite for a future GUI smoke test.

### Potential Workflow Conflict

- Linux checkout: `/home/darklove/projects/autonomous-uav-simulation`
- A separate Windows-host checkout exists outside the Linux filesystem.

All WSL development and generated outputs must remain in the Linux checkout.
Using the Windows-host copy from WSL risks performance, permission, line-ending,
synchronization, and operator-confusion problems.

### Checks Without Findings

- systemd reported no failed units.
- `dpkg --audit` reported no package database issues.
- No held packages or stack-related environment variables were reported.
- No PX4 or Gazebo simulation ports were observed listening.
- The clock was synchronized in the `Europe/Istanbul` timezone.

## Step 10 — Final Readiness Conclusion

**NOT READY for the PX4 SITL plus Gazebo smoke test.**

The Ubuntu 24.04 WSL2 foundation is suitable for controlled dependency setup:
the repository is on ext4, systemd and WSLg are available, hardware resources
are sufficient, NVIDIA GPU visibility works, and GitHub access is healthy.
Required build tools and simulation dependencies were not installed, and GUI
rendering had not been exercised.

A later task may perform the smallest explicitly approved dependency setup and
compatibility smoke test, then pin versions only after evidence is available.
The separate Windows-host checkout must remain outside the Linux development flow.
