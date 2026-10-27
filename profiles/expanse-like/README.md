# expanse-like

A login node that behaves like [SDSC Expanse](https://www.sdsc.edu/support/user_guides/expanse.html) for the
things agents and users run into. **Representative, not ground truth:** names follow Expanse's conventions,
but versions, node counts and paths are not checked against the live system.

## What's simulated

| Area | In the image | Real Expanse behaviour it mirrors |
|---|---|---|
| Modules | Lmod (EPEL) with a Spack-style hierarchy: `cpu/0.17.3b` and `gpu/0.17.3b` stacks (one Lmod `family`, so they swap) → `gcc/10.2.0` → `openmpi/4.1.3` → `gromacs/2020.4`; `cuda/11.2.2` in the gpu stack | Packages are hidden until their stack and compiler are loaded; only `module spider` sees everything; never both stacks at once |
| Login defaults | `cpu/0.17.3b` and `slurm` loaded at login (`LMOD_SYSTEM_DEFAULT_MODULES` + `module --initial_load restore`) | `module purge` drops `slurm`, so `srun`/`sbatch` disappear until it's reloaded |
| Software | Each module sets `*_HOME` and `PATH` under `/opt/software/spack/0.17.3b/<stack>/...`; the directories exist but are empty | Module environment only; there are no real compilers or applications |
| Slurm | `/opt/slurm/bin` (from the `slurm` module): `sinfo` prints a fixed Expanse-like partition table, `squeue`/`sacct` print headers (no jobs), `sbatch` prints a job id (`--test-only`: a start estimate) and runs nothing, `srun` runs the command on this machine, `salloc` "grants" an allocation and runs the command, `scancel` does nothing, `scontrol show partition` works | Client commands and their output shape; no scheduler, no accounting |
| Filesystems | `/expanse/lustre/scratch/$USER/temp_project` and `/expanse/lustre/projects` (ordinary directories) | Path layout only; no quotas, no Lustre, no purge |
| User state | Miniforge in `~/miniforge3`, `conda init` in `~/.bashrc` (so `base` auto-activates), one env at `/expanse/lustre/scratch/$USER/temp_project/envs/analysis` | A typical user setup, including an env on Lustre scratch |

Not simulated yet: quotas (`lfs quota`, home limits), `expanse-client`, GPU devices (`nvidia-smi`), real
Slurm daemons, a second user. The Slurm commands are short bash scripts; `file $(which sinfo)` would show it.

## Build and check

```bash
make build PROFILE=expanse-like
make test  PROFILE=expanse-like     # 12 checks, including "no giveaway words"
```
