## Configuration ESPHome pour PowerFlie v1.1

```
substitutions:
  name: powerflie
  disp_name: ${name}
  update_time: 2s

packages:
  remote_package:
    url: https://github.com/Enerwize/PowerFlies/v1.1/software/
    ref: master
    file: powerflie-1addon-factory.yaml
    refresh: 5s

esphome:
  name: ${name}
  name_add_mac_suffix: true

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
```
