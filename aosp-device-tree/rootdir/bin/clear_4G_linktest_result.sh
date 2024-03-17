#!/system/bin/sh
echo "start script"
filepath="/blackbox/4G_check.txt"

rm -f $filepath

if [ ! -f "$filepath" ]; then
    echo "clear success"
    setprop lte.dev.test start
    exit 0
else
    echo "clear fail"
    setprop lte.dev.test start
    exit 1
fi
