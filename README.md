# ESUMH
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

(E)nable (S)sh for (U)sername on (M)ultiple (H)ost

This script enables SSH for a user defined username on multiple hosts. Script is tested on AWS Ubuntu 18.04 (Bionic Beaver) instances.

### Prerequisites

Host Keys and script should be in same folder.

### How to run

To run the script replace

```
remoteHost=(host1, host2, host3, host4, host5)
```

with your **Host Address** and

```
remoteHostPass=(key1, key2, key3, key4, key5)
```
with **Hostkeys**. You can also the change the password of user which is currently **q6Y8jl9**.

When everything is set run the script with the argument USERNAME

```
sh ESUMH.sh USERNAME
```

## Built With

* [VScode](https://code.visualstudio.com/) - IDE
* [AWS](http://aws.amazon.com) - Cloud Service

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Chirayu kapoor**

## License

This project is licensed under the GNU V3.0 License - see the [LICENSE](LICENSE) file for details
