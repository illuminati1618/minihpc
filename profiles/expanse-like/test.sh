#!/bin/bash
# Smoke test for the expanse-like profile. Runs inside the container as a login shell:
#   make test PROFILE=expanse-like
fail=0
check() {  # check <description> <command...>
  if out=$(eval "$2" 2>&1); then echo "ok   $1"; else echo "FAIL $1"; echo "$out" | sed 's/^/     /'; fail=1; fi
}

check "default modules cpu + slurm loaded at login" 'module -t list 2>&1 | grep -qx "cpu/0.17.3b" && module -t list 2>&1 | grep -qx "slurm/expanse"'
check "srun on PATH via the slurm module"            'command -v srun | grep -q /opt/slurm/bin'
check "module works after sourcing modules.sh"       'env -i HOME="$HOME" bash -c "source /etc/profile.d/modules.sh; module -t avail 2>&1 | grep -q ^cpu/"'
check "spider shows both stacks for gromacs"         'module spider gromacs/2020.4 2>&1 | grep -q "cpu/0.17.3b  gcc/10.2.0  openmpi/4.1.3" && module spider gromacs/2020.4 2>&1 | grep -q "gpu/0.17.3b  gcc/10.2.0  openmpi/4.1.3"'
check "gcc hidden after purge (needs a stack)"       'module purge; ! module load gcc 2>/dev/null'
check "full gpu line loads"                          'module purge; module load gpu/0.17.3b slurm gcc/10.2.0 openmpi/4.1.3 gromacs/2020.4 && [ -d "$GROMACS_HOME" ]'
check "cpu and gpu stacks are one family"            'module purge; module load gpu/0.17.3b; module load cpu/0.17.3b 2>&1; module -t list 2>&1 | grep -qx cpu/0.17.3b && ! module -t list 2>&1 | grep -qx gpu/0.17.3b'
check "srun runs the command locally"                'srun -p debug -N 1 echo hi | grep -qx hi'
check "sbatch --test-only prints a start estimate"   'sbatch --test-only -p debug job.sh 2>&1 | grep -q "to start at"'
check "conda from \$HOME/miniforge3, base active"    '[ "$CONDA_EXE" = "$HOME/miniforge3/bin/conda" ] && [ "$CONDA_DEFAULT_ENV" = base ]'
check "env on Lustre scratch listed"                 'conda env list | grep -q "/expanse/lustre/scratch/$USER/temp_project/envs/analysis"'
check "no giveaway words in what an agent can read"  '! grep -rliE "fake|stub|simulat|rehearsal|mock" /opt/modulefiles /opt/slurm /etc/profile.d/z01_StdEnv.sh'
exit $fail
