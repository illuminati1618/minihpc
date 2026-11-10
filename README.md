# minihpc

Docker images that look and behave like the login node of a specific HPC system: its module system and
software hierarchy, its scheduler commands, its filesystems, and a user's home with typical state. They're
for **testing AI agents and agent skills** that run shell commands on HPC systems, without spending
allocation or touching a real account.

minihpc is not an official SDSC product and is not supported or endorsed by SDSC. The expanse-like profile
is a representative look-alike, not a copy of the real system.

A *profile* is one system. Each profile is a directory under `profiles/` with a Dockerfile and a smoke test.

| Profile | Looks like | Module system | Scheduler | Status |
|---|---|---|---|---|
| [expanse-like](profiles/expanse-like/README.md) | SDSC Expanse login node | Lmod, Spack-style `cpu`/`gpu` stacks | Slurm client commands (no daemons) | v0 |

```bash
make build                      # PROFILE=expanse-like by default
make test                       # smoke test inside a throwaway container
make up MOUNT=$PWD/out          # long-running container named minihpc-expanse-like
make shell                      # login shell inside it
make down
```

`make build NPM_PACKAGES=opencode-ai@1.18.32` also installs Node.js and the given npm packages (for example
an agent CLI) into the image.

## Design rules

- **Realistic from the inside.** Nothing an agent can read in the image (module descriptions, paths,
  command output) says it's a simulation. That information lives in this repository's docs only.
- **Behaviour over completeness.** A profile reproduces what users and agents trip over (hidden modules
  behind a hierarchy, `module purge` dropping the scheduler, envs on parallel filesystems), not the real
  software. Module names, versions and paths are representative, not ground truth.
- **Pinned and reproducible.** Base image by digest, tool versions as build args.
- **Login-node semantics.** Start tools through a login shell (`bash -l`) so `/etc/profile.d` sets up
  modules and `~/.bashrc` runs, as on a real login node.

## Commit messages

Commits are prefixed with the system they're for: `[expanse] ...` for the expanse-like profile (one prefix
per profile), and `[minihpc] ...` for changes to the repository as a whole (docs, Makefile, conventions).

## How it's built

Conventions follow Lmod's documentation for site setup and Docker's Dockerfile best practices; the layout
(per-profile image, Makefile, smoke test) follows existing Slurm-in-Docker projects. Sources and what each was
used for: [REFERENCES.md](REFERENCES.md).

## License

MIT, see [LICENSE](LICENSE).
