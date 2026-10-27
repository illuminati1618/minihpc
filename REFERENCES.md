# References

Every source consulted while designing minihpc, and what it was used for. Checked 2026-10-26.

## Structure and prior art

| Source | Used for |
|---|---|
| [giovtorres/slurm-docker-cluster](https://github.com/giovtorres/slurm-docker-cluster) (MIT, ~550 stars) | The most-used Slurm-in-Docker project. Took its shape: versions as build args, a `Makefile` front end, and test scripts next to the images. It runs real Slurm daemons in docker-compose; minihpc doesn't (yet), because agent tests only need a login node's client commands. |
| [ubccr/hpc-toolset-tutorial](https://github.com/ubccr/hpc-toolset-tutorial) (GPL-3.0, archived) | An HPC-center-in-Docker for training (one directory per service, a helper script). Confirms the per-component directory layout; also a reminder that it's archived and uses insecure defaults, which is fine for local testing only. |
| [SciDAS lmod-modules-centos](https://github.com/scidas/lmod-modules-centos) | An existing Lmod-in-Docker setup: base image plus per-package modulefiles under a `modulefiles/` tree with software in a parallel tree. Same split as `/opt/modulefiles` + `/opt/software` here. |
| [BSC docker-cluster](https://storage.bsc.es/gitlab/hpc/docker-cluster/-/raw/main/README.md), [ClusterCockpit cc-docker slurm](https://git.clustercockpit.org/ClusterCockpit/cc-docker/raw/commit/0edb94da94427f33163b7f09c2fefaf60bdeed7e/slurm/README.md) | More Slurm-in-Docker clusters (both derived from giovtorres' work); none model a site's module environment, which is the gap minihpc fills. |

## Lmod

| Source | Used for |
|---|---|
| [Lmod: standard modules](https://lmod.readthedocs.io/en/latest/070_standard_modules.html) | Login defaults: `/etc/profile.d/z01_StdEnv.sh` with the `__Init_Default_Modules` guard, `LMOD_SYSTEM_DEFAULT_MODULES` and `module --initial_load --no_redirect restore` (`--no_redirect` keeps scp working). |
| [Lmod: installing](https://lmod.readthedocs.io/en/latest/030_installing.html) | Initial `MODULEPATH` from `/etc/lmod/.modulespath` (leading dot; `LMOD_MODULEPATH_INIT` overrides it). An earlier draft used `/etc/lmod/modulespath`, which Lmod ignores. |
| [Lmod: modulefile examples](https://lmod.readthedocs.io/en/latest/100_modulefile_examples.html) | `whatis`, `family`, `prepend_path("MODULEPATH", ...)` for the hierarchy. |
| [Spack: modules](https://spack.readthedocs.io/en/latest/module_file_support.html) | Hierarchy layers (Core → compiler → MPI) and the `{name}/{version}` naming that Spack-built sites such as Expanse expose. |

## Docker

| Source | Used for |
|---|---|
| [Docker: building best practices](https://docs.docker.com/build/building/best-practices/) | Base image pinned by digest, sorted one-per-line package lists, `pipefail` shell, package-manager cleanup in the same `RUN`, OCI `LABEL`s, a non-root user with a fixed UID, `.dockerignore`. |
| [rockylinux/rockylinux on Docker Hub](https://hub.docker.com/r/rockylinux/rockylinux) | Base image. The Rocky project maintains this one; the Docker Official `rockylinux:9` tag was still Rocky 9.3 on 2026-10-26. Expanse runs a RHEL-family OS. |
| [conda-forge/miniforge releases](https://github.com/conda-forge/miniforge/releases) | Pinned Miniforge `26.7.2-0` (Sept 2026), not the newest release that came out the same week. |

## The system being imitated

| Source | Used for |
|---|---|
| [SDSC Expanse user guide](https://www.sdsc.edu/support/user_guides/expanse.html) | Partition names and time limits, `cpu`/`gpu` software stacks, `module load slurm`, Lustre scratch layout, conda-in-`$HOME` advice. |
