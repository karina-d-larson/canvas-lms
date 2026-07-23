# AWS + Canvas Runbook

## Goal

Prepare and verify the brownfield Canvas LMS development environment on AWS Academy EC2 so the next lab can implement **Preference Storage** (`feature-preference-storage`) against a running Docker-based Canvas. This runbook does **not** implement that feature.

**Policy:** No AWS keys, session tokens, PATs, passwords, private keys, or `.env` values are stored here.

---

## Current Environment

| Item | Value (safe) |
|------|----------------|
| Environment | AWS Academy EC2 + Cursor Remote SSH |
| Repository path | `/home/ubuntu/canvas-lms` |
| Fork | `https://github.com/karina-d-larson/canvas-lms.git` (`origin`) |
| Current branch | `dev` @ `08b567d88d5` |
| Default branch (remote) | `master` |
| Upstream remote | Not configured |
| OS | Ubuntu 22.04 (AWS kernel 6.8.x) |
| Instance class (IMDS) | `t3.large` (AZ `us-east-1c`) |
| Memory / disk (Lab 3.1 check) | ~7.6 GiB RAM; root ~29G with ~7.7G free (~74% used) |
| Setup method (from repo docs) | **Docker Compose** development path (`doc/docker/README.md`, `./script/docker_dev_setup.sh`) |
| EC2 access pattern | Publish Canvas on host **port 80** via `docker-compose.ec2-access.yml` (no Dory) |
| Boot automation | `canvas-docker.service` (enabled) |

Public IP / full instance IDs: keep in AWS console / private lab notes (not duplicated here).

---

## AI-Assisted Procedure

During Lab 3.1, AI:

1. Confirmed repository root, branch, commit, and dirty/untracked status.
2. Read agent planning artifacts and Preference Storage research (**without implementing**).
3. Followed in-repo Docker docs to confirm Docker Compose is the intended local path (not assumed from generic Canvas memory).
4. Inspected Docker daemon, compose services, systemd boot unit, listening ports, and HTTP responses.
5. Interpreted results: stack already running; strongest verification is containers **Up** + HTTP **302** + login HTML on port 80.
6. Updated durable notes (`memory-practice.md`, this runbook) with last-verified metadata.

No feature code, commits, pushes, or AWS resource mutations were performed for this lab.

---

## Learner Lab and EC2 Checklist

| Item | Status |
|------|--------|
| Learner Lab active | **Human verification required** (Academy console) |
| EC2 instance running | **Verified** (SSH + IMDS responding) |
| SSH / Cursor Remote SSH | **Verified** |
| Disk space adequate | **Verified with caution** (~7.7G free; avoid large rebuilds without cleanup) |
| Memory adequate for Docker Canvas | **Verified** (~7.6 GiB on `t3.large`) |
| Security group TCP **80** from your IP | **Human verification required** |
| Repository present at `/home/ubuntu/canvas-lms` | **Verified** |
| Secrets excluded from git/runbook | **Verified policy** (do not commit `.env`, PATs, keys) |

---

## Canvas Documentation Followed

| Path | Why it mattered |
|------|-----------------|
| `README.md` | Points to wiki Quick Start / Production Start; confirms official install docs exist |
| `doc/docker/README.md` | Canonical Docker path: `./script/docker_dev_setup.sh`, then `docker compose up -d`; Linux ACL notes |
| `doc/docker/developing_with_docker.md` | Manual compose steps, `canvas.docker` access pattern, update script |
| `doc/docker/getting_docker.md` | Docker prerequisite guidance |
| `docker-compose.yml` | Base `web` / `jobs` / `postgres` / `redis` services |
| `config/docker-compose.override.yml.example` | Default override volume/env pattern |
| `script/docker_dev_setup.sh` | Automated image build, assets, DB setup |
| `docker-compose.ec2-access.yml` | EC2-specific port **80** publish + restart policies (local lab file) |
| `agents/scripts/start-canvas-docker.sh` | Repeatable start + HTTP wait loop |
| `agents/scripts/canvas-docker.service` | systemd auto-start on boot |

**Summary:** Repository documentation selects **Docker Compose** for development. On this EC2 host, Dory/`canvas.docker` proxy is optional; host port **80** is used instead.

---

## Commands and Procedure

### Environment inspection

```bash
pwd
uname -a
free -h
df -h /
# IMDS (non-secret metadata only)
curl -s http://169.254.169.254/latest/meta-data/instance-type
```

### Repository state

```bash
cd /home/ubuntu/canvas-lms
git branch --show-current
git rev-parse --short HEAD
git status -sb
git remote -v
```

### Dependencies or services

```bash
docker --version
docker compose version
systemctl is-active docker
systemctl is-active canvas-docker
systemctl is-enabled canvas-docker
docker compose ps
ss -tlnp | grep -E ':80|:5432|:6379'
```

### Canvas startup (when stopped)

Preferred (boot service):

```bash
sudo systemctl start canvas-docker
# or
sudo systemctl restart canvas-docker
```

Manual:

```bash
cd /home/ubuntu/canvas-lms
./agents/scripts/start-canvas-docker.sh
# equivalent core:
docker compose up -d postgres redis webpack web jobs
```

Initial full bootstrap (already done historically; only if rebuilding):

```bash
# Follow doc/docker/README.md
./script/docker_dev_setup.sh
# Linux permissions: setfacl / docker group as documented
```

### Verification

```bash
docker compose ps
curl -sI -m 10 http://127.0.0.1/ | head -5
curl -s -o /dev/null -w '%{http_code}\n' -m 10 http://127.0.0.1/login
curl -sL -m 10 http://127.0.0.1/login | head -5
```

From your laptop (after SG allows TCP 80): `http://<EC2_PUBLIC_IP>/`

---

## Verification

| Check | Command or method | Expected signal | Actual result (2026-07-23) |
| ----- | ----------------- | --------------- | -------------------------- |
| Docker Compose installed | `docker compose version` | Version string | **Pass** — 2.40.3 |
| Core containers Up | `docker compose ps` | `web`, `jobs`, `postgres`, `redis` (and ideally `webpack`) Up | **Pass** — all five Up |
| Port 80 listening | `ss` / compose ports | `0.0.0.0:80->80/tcp` | **Pass** |
| HTTP root | `curl -sI http://127.0.0.1/` | 200/301/302 from Canvas | **Pass** — **302 Found** |
| Login route | `curl` `/login` | Redirect or HTML login | **Pass** — **302**; HTML `<html ...>` login page body |
| Boot service | `systemctl is-active/enabled canvas-docker` | active + enabled | **Pass** |
| Off-instance browser | Browser to public IP:80 | Canvas login UI | **Not verified this session** (human) |
| Learner Lab active | AWS Academy console | Lab session not expired | **Human verification required** |

**Strongest successful checkpoint:** Docker Canvas stack running with host port **80** returning Canvas HTTP **302** and a login HTML page on the instance.

---

## Known Issues and Next Step

| Issue | Severity | Notes |
|-------|----------|-------|
| Disk ~74% full | Medium | Free space before `docker compose build` |
| Off-instance access | Info | Confirm security group TCP 80 |
| Compose `version` attribute warnings | Low | Obsolete key warning; non-blocking |
| Admin password | Info | Store only in private lab journal |

**Next documented command if stack is down:** `sudo systemctl start canvas-docker` or `./agents/scripts/start-canvas-docker.sh`, then re-run the verification `curl` checks.

**Human:** Confirm Learner Lab active and capture a browser screenshot of the Canvas login page from your laptop if required for submission.

---

## Integration With Memory Practice

See `agents/memory-practice.md` (last-verified metadata technique).

### Last Verified (runbook)

- Verification date: `2026-07-23` (UTC ~03:29)
- Branch: `dev`
- Commit: `08b567d88d5`
- Environment checkpoint: Docker Compose Canvas Up; HTTP 302 on `:80`; `canvas-docker` enabled
- Conditions requiring refresh: branch/SHA change; compose/port changes; EC2 reboot with failed service; disk exhaustion; HTTP failure on `:80`

---

## Ready for Next Lab

### Ready

* Fork checkout on EC2 with Docker-based Canvas **running** (instance-local HTTP verified)
* Preference Storage research: `agents/tasks/feature-preference-storage/{feature,implementation-research}.md`
* Project-creation agent spec: `agents/project-creation.md`
* Repo analysis agent guidance: `agents/analyze-repo.md`
* Memory practice procedure documented for brownfield re-grounding
* Boot-time Docker start configured via systemd

### Out of scope for this lab

* Preference Storage feature coding
* Production deployment
* Unrelated Canvas refactoring
* Broad AWS architecture / IAM / networking redesign

Feature implementation belongs to the **next** lab.
