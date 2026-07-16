# Phase 1A PX4 SITL and Gazebo Harmonic Installation

## Installation Metadata

- **Installation date:** 2026-07-16
- **Host environment:** Ubuntu 24.04.3 LTS on WSL2
- **Project repository:** /home/darklove/projects/autonomous-uav-simulation
- **PX4 source:** /home/darklove/src/PX4-Autopilot
- **PX4 release:** v1.17.0
- **PX4 commit:** d6f12ad1c4f70ad3230afd7d86e971421e02fef4
- **Scope:** Minimum PX4 SITL, Gazebo Harmonic, and X500 toolchain

## Outcome

**READY TO RESTART WSL FOR THE DEFERRED PX4 SITL PLUS GAZEBO X500
SMOKE TEST. NOT YET RUNTIME-VALIDATED.**

The approved dependency installation and static verification completed. The
final make px4_sitl gz_x500 smoke test was intentionally not run in this phase.
WSL must be restarted before that test is attempted.

## PX4 Source Selection

PX4 was cloned from the official repository into the approved source location,
outside the project repository:

~~~text
Repository: https://github.com/PX4/PX4-Autopilot.git
Location:   /home/darklove/src/PX4-Autopilot
Tag:        v1.17.0
Commit:     d6f12ad1c4f70ad3230afd7d86e971421e02fef4
~~~

The repository and recursive submodules were checked out. The first clone
orchestration timed out while Git was still running and left seven nested
submodule worktrees without checked-out files. Inspection showed intact Git
objects, expected commits, no staged content, and no user changes. The checkout
was repaired with:

~~~bash
git submodule update --init --recursive --force
~~~

The final PX4 worktree is clean and the release tag resolves exactly to the
selected commit.

## Installation Method

The exact setup script from the selected PX4 release was run as follows:

~~~bash
cd /home/darklove/src/PX4-Autopilot
sudo bash Tools/setup/ubuntu.sh --no-nuttx
~~~

The --no-nuttx option kept this phase scoped to SITL. It skipped the NuttX
hardware toolchain, serial-group setup, and shell PATH modification. No shell
configuration file was changed.

Verified input hashes:

| File | SHA-256 |
| --- | --- |
| Tools/setup/ubuntu.sh | 8ae8b49abee4ad1d81e0e26034fbaa94cfe7466bea85c5eee8505d6eb4a39916 |
| Tools/setup/requirements.txt | 880c160451b4658c2282a1838efd6626314d7ddad4bdedb6a032c4b5bb43638f |

The official script added the OSRF Gazebo package source for Ubuntu Noble and
installed the gz-harmonic metapackage. No package repository was added
manually. No apt upgrade command was run. The apt install transaction did
upgrade 37 already-installed dependency packages while resolving the approved
toolchain installation.

The script also installed its pinned or constrained Python requirements
system-wide under /usr/local/lib/python3.12/dist-packages, as designed by the
PX4 Ubuntu 24.04 setup path.

## Verified Versions

| Component | Verified value |
| --- | --- |
| PX4-Autopilot | v1.17.0 at d6f12ad1c4f70ad3230afd7d86e971421e02fef4 |
| Gazebo Harmonic metapackage | gz-harmonic 1.0.0-1~noble |
| Gazebo Sim | 8.14.0 / libgz-sim8 8.14.0-1~noble |
| CMake | 3.28.3 |
| Ninja | 1.11.1 |
| ccache | 4.9.1 |
| GDB | 15.1 |
| pkg-config | 1.8.1 |
| Python | 3.12.3 |
| empy | 3.3.4 |
| pymavlink | 2.4.49 |
| NumPy | 2.5.1 |
| pyulog | 1.2.3 |
| kconfiglib | 14.1.0 |

## Verification Results

| Check | Result |
| --- | --- |
| Official setup log | Completed through Setting up gz-harmonic; no error marker found |
| Package database | dpkg --audit produced no findings |
| Dependency consistency | apt-get check --simulate completed without an error |
| Python dependency consistency | python3 -m pip check reported no broken requirements |
| PX4 worktree | Clean; git diff --check passed |
| systemd | running; zero failed units |
| Linux filesystem free space | Approximately 917 GiB after installation |
| X500 airframe | ROMFS/px4fmu_common/init.d-posix/airframes/4001_gz_x500 present |
| X500 model | Tools/simulation/gz/models/x500/model.sdf present |
| X500 target mapping | PX4 release docs map make px4_sitl gz_x500 to airframe 4001 |
| Reboot marker | /var/run/reboot-required was not present |

pip emits an Ubuntu package metadata warning for the distro-provided
pybind11-2.11.1.dist-info. The module imports successfully as version 2.11.1,
and pip check reports no broken requirements. This is recorded as a
non-blocking observation.

The official setup script created a root-owned wget-log in the PX4 root while
downloading the OSRF signing key. Its content and timestamp identified it as
installation output; it was removed after inspection so the new PX4 checkout
remained clean.

## Explicitly Not Installed or Run

- ROS 2
- MAVSDK
- QGroundControl
- Docker images or containers
- Gazebo Classic system packages
- NuttX hardware toolchain
- Real-flight hardware configuration
- Arming or actuator-control code
- PX4 build or simulation smoke test

The recursive official PX4 checkout contains its historical
Tools/simulation/gazebo-classic source submodule, but Gazebo Classic is not
installed on the system. The installed pymavlink Python package is a PX4 setup
requirement and is not MAVSDK.

No commit or push was performed.

## Deferred Post-Restart Check

Restart only the Ubuntu distribution from PowerShell before the next phase:

~~~powershell
wsl --terminate Ubuntu-24.04
~~~

Reopen Ubuntu, return to /home/darklove/src/PX4-Autopilot, and perform the
separately approved smoke test in the next task. The expected command, not run
in Phase 1A, is:

~~~bash
make px4_sitl gz_x500
~~~

Official references:

- [PX4 Ubuntu development environment](https://docs.px4.io/v1.17/en/dev_setup/dev_env_linux_ubuntu)
- [PX4 Gazebo simulation](https://docs.px4.io/v1.17/en/sim_gazebo_gz/)
- [PX4 Gazebo vehicles and X500 target](https://docs.px4.io/v1.17/en/sim_gazebo_gz/vehicles)
