#!/bin/bash

IFACE=wlan0

for AUTH in {0,2} ; do
    for FRAGM in {1140,1740,2340} ; do
        for RTS in {1140,1740,2340} ; do
            for BEACON in {50,100,150} ; do
                for TXPOW in {9,12,15} ; do
                    echo "Experiment AUTH=$AUTH FRAGM=$FRAGM RTS=$RTS BEACON=$BEACON TXPOW=$TXPOW"
                    cp hostapd_original.conf hostapd.conf
                    sed -i "s/fragm_threshold=1140/fragm_threshold=${FRAGM}/g" hostapd.conf
                    sed -i "s/rts_threshold=1140/rts_threshold=${RTS}/g" hostapd.conf
                    sed -i "s/beacon_int=1140/beacon_int=${BEACON}/g" hostapd.conf
                    sed -i "s/wpa=0/wpa=${AUTH}/g" hostapd.conf
                    iwconfig $IFACE txpower $TXPOW
                    killall hostapd
                    sleep 1
                    hostapd hostapd.conf &
                    sleep 1
                    read -n1 -r -p "Run your experiment and then press any key to continue..." key
                    echo ""
                done
            done
        done
    done
done

