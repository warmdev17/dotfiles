#!/usr/bin/env bash

TOUCHPAD="pnp0c50:0e-06cb:7e7e-touchpad"

disableTouchpad() {
  hyprctl keyword "device[$TOUCHPAD]:enabled" false
}

enableTouchpad() {
  hyprctl keyword "device[$TOUCHPAD]:enabled" true
}

swayidle -w timeout 1 'disableTouchpad' resume 'enableTouchpad'
