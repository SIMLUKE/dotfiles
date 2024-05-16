figlet "$(date "+%H : %M")"
echo "battery at : $(cat /sys/class/power_supply/BAT0/capacity)%"
echo "battery $(cat /sys/class/power_supply/BAT0/status)"
