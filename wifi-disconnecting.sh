#!/bin/bash

desired_value="2"
config_file="/etc/NetworkManager/conf.d/default-wifi-powersave-on.conf"

# Check if the file exists and if the current value is not already 2
if [ -f "$config_file" ]; then

    current_value=$(awk -F'=' '/wifi.powersave/{print $2}' "$config_file")
    current_value="${current_value// /}"  # Remove leading/trailing spaces

    if [ "$current_value" != "$desired_value" ]; then

        sudo sed -i "s/wifi.powersave.*/wifi.powersave = $desired_value/" "$config_file"

        sudo systemctl restart NetworkManager
        echo "Wi-Fi powersave mode has been set to $desired_value."
    else
        echo "Wi-Fi powersave mode is already set to $desired_value."
    fi
else

    # If the file doesn't exist, create it with the desired value
    echo "[connection]" | sudo tee "$config_file"
    echo "wifi.powersave = $desired_value" | sudo tee -a "$config_file"

    sudo systemctl restart NetworkManager
    echo "Wi-Fi powersave mode has been set to $desired_value."
fi
