#!/vendor/bin/sh

########################################################
### init.insmod.cfg format:                          ###
### -----------------------------------------------  ###
### [insmod|setprop|enable/moprobe] [path|prop name] ###
### ...                                              ###
########################################################

if [ $# -eq 1 ]; then
  cfg_file=$1
else
  exit 1
fi

if [ -f $cfg_file ]; then
  while IFS="|" read -r action arg
  do
    case $action in
      "insmod") insmod $arg ;;
      "setprop")
        times=1
        setprop $arg 1
        while [ "$?" -ne 0 ]
        do
          if [ $times -gt 128 ]; then
            break
          fi
          let times++
          setprop $arg 1
        done ;;
      "enable") echo 1 > $arg ;;
      "modprobe")
        insmod_arg=${arg}
        for partition in system_dlkm vendor
        do
          modules_dir_base="/${partition}/lib/modules"
          for modules_dir in ${modules_dir_base}/*/ ${modules_dir_base}
          do
            if [ ! -f "${modules_dir}/modules.load" ]; then
              continue
            fi
            case ${insmod_arg} in
              "-b *" | "-b")
                arg="-b $(cat ${modules_dir}/modules.load)" ;;
              "*" | "")
                arg="$(cat ${modules_dir}/modules.load)" ;;
            esac
            modprobe -a -d ${modules_dir} $arg
          done
        done
    esac
  done < $cfg_file
else
  exit 2
fi

