# Memory Practice — Last-Verified Metadata

## Technique

**Last-verified metadata with explicit re-grounding and summarization triggers**

**Last-verified metadata** is a short, dated checkpoint that records *when* and *against which repository state* an agent last confirmed facts (branch, commit, files read, environment signals). It is not a full transcript and not a substitute for source code.

**Why it fits Canvas LMS:** This fork is a large brownfield Rails + React codebase. Agent notes about controllers, ENV injection, preferences, Docker compose, or ports go stale after pulls, branch switches, dependency changes, or EC2 restarts. Explicit verification timestamps force agents to treat prior chat and old markdown as *hypotheses* until rechecked.

**Short-term vs durable memory:**

| Layer | Contents | Lifetime |
|-------|----------|----------|
| Session working summary | Current goal, last commands, open blockers | One session; compress or discard at end |
| Durable agent artifacts | `analyze-repo.md`, `project-creation.md`, feature research | Persist in git; refresh when code/env changes |
| Last-verified block | Date, branch, SHA, sources, env checkpoint | Updated at session start/end and after triggers |

**Reread rule:** Prefer opening the cited file at the current commit over trusting earlier conversation paraphrases. Chat memory is lossy; `git` + file contents are authoritative.

---

## Connection to existing agents

| Artifact | Role as durable memory | Refresh when |
|----------|------------------------|--------------|
| `agents/analyze-repo.md` | How to analyze the brownfield repo with indexes | Index scripts or analysis strategy change |
| `agents/project-creation.md` | How to create GitHub Project/issues for Feature 1 | Fork target, feature paths, or handoff IDs change |
| `agents/tasks/feature-preference-storage/implementation-research.md` | Primary FR/TR/Lab 4 handoff for Preference Storage | Requirements, affected files, or DoD change |
| `agents/tasks/feature-preference-storage/feature.md` | Scope / out-of-scope framing | Scope decisions change |
| `agents/aws-canvas-runbook.md` | EC2 + Docker Canvas operational checkpoint | Instance size, ports, compose files, or boot service change |

These files are **project memory**, not live truth. After a commit/branch/env change, re-ground by rereading the relevant sections and updating the Last Verified block below (or in the runbook).

---

## Operational procedure

1. **Session start — record metadata**
   - Date/time (UTC)
   - Branch and short commit SHA
   - `git status` summary (clean / dirty / untracked categories only)
   - Agent artifacts consulted
2. **Reread** the source files needed for the task (do not rely only on prior chat).
3. **Keep a short session working summary** (goal, last successful checkpoint, next command). Avoid carrying full earlier conversation text.
4. **Re-ground after any of:**
   - Pulling / merging / switching branches
   - Changing dependencies (`package.json`, Gemfile, images)
   - Changing DB or environment configuration
   - Resuming after a long gap
   - Discovering code that conflicts with an agent note
5. **Session end**
   - Record what was verified
   - Record unresolved questions
   - Drop temporary command noise
   - Do **not** promote guesses into durable notes

### Reusable metadata block

```markdown
## Last Verified

- Verified at:
- Branch:
- Commit:
- Repository status:
- Sources checked:
- Environment checkpoint:
- Refresh required after:
```

---

## Purge and refresh policy

* Temporary command dumps and speculative notes are **not** long-term memory; summarize then discard.
* Replace or compress old session summaries when they repeat the same checkpoint.
* Architecture or implementation claims must be rechecked when **branch or commit** changes.
* **Never** store secrets (PATs, passwords, AWS keys, private keys, `.env` values) in memory files.

---

## Failure modes and mitigations

| Failure mode | Mitigation |
|--------------|------------|
| Stale repository understanding | Compare current SHA to Last Verified; reread cited paths before editing or planning |
| Over-retention of noisy session details | End-of-session purge; keep only checkpoint + blockers |
| Treating an agent summary as more trustworthy than source code | Prefer file + `git` evidence; demote markdown claims that conflict |
| Carrying environment-specific assumptions into a different EC2 session | Re-run `docker compose ps`, port/`curl` checks; update Environment checkpoint |

---

## Evidence of actual use (Lab 3.1 session)

Redacted session log showing this procedure was applied:

### Last Verified

- Verified at: `2026-07-23T03:29:09Z` (UTC)
- Branch: `dev`
- Commit: `08b567d88d5`
- Repository status: dirty — untracked agent/docs/scripts and `docker-compose.ec2-access.yml` (not committed this lab)
- Sources checked:
  - `agents/analyze-repo.md`
  - `agents/project-creation.md`
  - `agents/tasks/feature-preference-storage/feature.md`
  - `agents/tasks/feature-preference-storage/implementation-research.md`
  - `README.md`, `doc/docker/README.md`, `doc/docker/developing_with_docker.md`
  - `docker-compose.yml`, `docker-compose.ec2-access.yml`, `agents/scripts/start-canvas-docker.sh`
- Environment checkpoint:
  - Official path: Docker Compose via `doc/docker/README.md` / `./script/docker_dev_setup.sh`
  - Instance class (IMDS): `t3.large`; OS Ubuntu 22.04 (kernel 6.8 AWS)
  - Docker Compose services **Up**: `web`, `jobs`, `webpack`, `postgres`, `redis`
  - Host port **80** mapped to web; `curl` → HTTP **302** on `/` and `/login`; login HTML returned
  - `canvas-docker.service`: **active** and **enabled**
  - Disk ~74% used on root (`7.7G` free) — monitor before large rebuilds
- Refresh required after: `git pull` / branch switch; compose config changes; EC2 stop/start; disk pressure; failed HTTP on `:80`

### Session working summary

- Goal: Lab 3.1 memory practice + AWS/Canvas verification (no feature coding).
- Strongest Canvas signal: containers healthy + HTTP 302 + login page HTML on `http://127.0.0.1/`.
- Not claimed: off-instance browser access (security group / public IP — **human verification required**).
- Out of scope this lab: Preference Storage implementation.

### Unresolved / human

- Learner Lab “active” status: confirm in AWS Academy console (not asserted from IMDS alone).
- Browser from laptop: open `http://<EC2_PUBLIC_IP>/` with TCP **80** allowed.
- Admin credentials: keep in private lab journal only (not in git).
