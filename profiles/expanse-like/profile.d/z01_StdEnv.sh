# Load the site default modules once per login, following Lmod's "standard modules" recipe:
# https://lmod.readthedocs.io/en/latest/070_standard_modules.html
if [ -z "$__Init_Default_Modules" ]; then
  export __Init_Default_Modules=1
  export LMOD_SYSTEM_DEFAULT_MODULES=${LMOD_SYSTEM_DEFAULT_MODULES:-"cpu/0.17.3b:slurm"}
  module --initial_load --no_redirect restore
else
  module refresh
fi
