# multiflexi-mtr

check your network using MultiFlexi

![MultiFlexi MTR](multiflexi/7492e4fe-0192-434b-b9c0-2497a360e17c.svg?raw=true)

Example of result:

```json
{
    "report": {
        "mtr": {
            "src": "gamer",
            "dst": "1.1.1.1",
            "tos": 0,
            "tests": 10,
            "psize": "64",
            "bitpattern": "0x00"
        },
        "hubs": [
            {
                "count": 1,
                "host": "router.vitexsoftware.brevnov.czf",
                "Loss%": 0.0,
                "Snt": 10,
                "Last": 0.366,
                "Avg": 0.396,
                "Best": 0.327,
                "Wrst": 0.463,
                "StDev": 0.035
            },
            {
                "count": 2,
                "host": "vlan1143-router.arachne.brevnov.czf",
                "Loss%": 0.0,
                "Snt": 10,
                "Last": 1.021,
                "Avg": 1.621,
                "Best": 0.54,
                "Wrst": 3.156,
                "StDev": 1.118
            },
            {
                "count": 3,
                "host": "vlan12.gw-tower.brevnov.czf",
                "Loss%": 0.0,
                "Snt": 10,
                "Last": 1.061,
                "Avg": 1.649,
                "Best": 0.831,
                "Wrst": 3.389,
                "StDev": 1.0
            },
            {
                "count": 4,
                "host": "vlan772-argo.sit-asbr1.spoje.net",
                "Loss%": 0.0,
                "Snt": 10,
                "Last": 3.579,
                "Avg": 2.447,
                "Best": 0.949,
                "Wrst": 5.245,
                "StDev": 1.525
            },
            {
                "count": 5,
                "host": "czfpha-spoj-vl3812.nfx.cz",
                "Loss%": 0.0,
                "Snt": 10,
                "Last": 1.321,
                "Avg": 2.319,
                "Best": 0.869,
                "Wrst": 4.325,
                "StDev": 1.33
            },
            {
                "count": 6,
                "host": "nix4.cloudflare.com",
                "Loss%": 0.0,
                "Snt": 10,
                "Last": 2.451,
                "Avg": 8.016,
                "Best": 1.643,
                "Wrst": 20.755,
                "StDev": 7.767
            },
            {
                "count": 7,
                "host": "one.one.one.one",
                "Loss%": 0.0,
                "Snt": 10,
                "Last": 1.127,
                "Avg": 1.763,
                "Best": 1.127,
                "Wrst": 3.302,
                "StDev": 0.808
            }
        ]
    }
}
```

## MultiFlexi

**MTR** is ready for run as [MultiFlexi](https://multiflexi.eu) application.
See the full list of ready-to-run applications within the MultiFlexi platform on the [application list page](https://www.multiflexi.eu/apps.php).

[![MultiFlexi App](https://github.com/VitexSoftware/MultiFlexi/blob/main/doc/multiflexi-app.svg)](https://www.multiflexi.eu/apps.php)

Installation
------------

The repository with packages for Debian & Ubuntu is availble:

```shell
sudo apt install lsb-release wget apt-transport-https bzip2
wget -qO- https://repo.vitexsoftware.com/keyring.gpg | sudo tee /etc/apt/trusted.gpg.d/vitexsoftware.gpg
echo "deb [signed-by=/etc/apt/trusted.gpg.d/vitexsoftware.gpg]  https://repo.vitexsoftware.com  $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/vitexsoftware.list
sudo apt update
sudo apt install multiflexi-mtr
```
