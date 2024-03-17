#!/system/bin/sh

echo 'dongle upgrade start' >> /blackbox/dongleupdate.txt
setprop lte.dev.update test
i=1
while [ $i -le 1000 ]
do

    echo '                                       ' >> /blackbox/dongleupdate.txt
    echo '                                       ' >> /blackbox/dongleupdate.txt
    echo '********************************************************************' >> /blackbox/dongleupdate.txt
    echo $i >> /blackbox/dongleupdate.txt

    echo '                                       ' >> /blackbox/dongleupdate.txt
    echo start upgrade
    echo 'start upgrade' >> /blackbox/dongleupdate.txt
    date >> /blackbox/dongleupdate.txt
    dji_mb_ctrl -S test -R diag -g 08 -t 06 -s 18 -c 3d  01616161616161616161616161616161
    sleep 360

    echo start downgrade
    echo '                                       ' >> /blackbox/dongleupdate.txt
    echo 'start downgrade' >> /blackbox/dongleupdate.txt
    date >> /blackbox/dongleupdate.txt
    dji_mb_ctrl -S test -R diag -g 08 -t 06 -s 18 -c 3d  03616161616161616161616161616161
    sleep 360

    let i++
done

echo 'dongle upgrade over' >> /blackbox/dongleupdate.txt
