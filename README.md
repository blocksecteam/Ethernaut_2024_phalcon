# Ethernaut CTF 2024 - Phalcon Fork Version 🚩

[![Twitter Follow](https://img.shields.io/twitter/follow/Phalcon_xyz?label=Follow%20%40Phalcon_xyz&style=social)](https://twitter.com/Phalcon_xyz)

See [README-CTF.md](README-CTF.md) for original Ethernaut CTF 2024 README.

## Phalcon Forks

| Challenge       | Status | Description |
|:----------------|:------:|:-----------:|
| Alien Spaceship |   🟢   | Explore in [Phalcon Fork Scan](https://phalcon.blocksec.com/fork/scan/fork_0a11ba6d2c634627b7b7dc801070dfa1) |
| beef            |   🟢   | Explore in [Phalcon Fork Scan](https://phalcon.blocksec.com/fork/scan/fork_86c86ec4385a4c17a9ede3719537b981) |
| Dutch           |   🟡   | Currently vyper contract verification not supported, See [Phalcon Fork Scan](https://phalcon.blocksec.com/fork/scan/fork_17db3a05691b4bcf9ecb4fbf31e7fefe) |
| Dutch 2         |   🟡   | Currently vyper contract verification not supported, See [Phalcon Fork Scan](https://phalcon.blocksec.com/fork/scan/fork_5f90c684ac024254b1843551208497ba) |
| Greedy Sad Man  |   🔴   | Currently StarkNet fork not supported |
| Space Bank      |   🟢   | Explore in [Phalcon Fork Scan](https://phalcon.blocksec.com/fork/scan/fork_04e042aee5e648beb3e534c1029dbdf0) |
| start.exe       |   🔴   | Sign-in challenge with on-chain deployment |
| Wombo Combo     |   🟢   | Explore in [Phalcon Fork Scan](https://phalcon.blocksec.com/fork/scan/fork_d6cc482d0fdf4683bd41ffb820a69157) |
| XYZ             |   🟢   | Explore in [Phalcon Fork Scan](https://phalcon.blocksec.com/fork/scan/fork_0805fbb57ae1463bbcf15103d443861f) |

## Quick Start

### Deploy

Make sure you have installed all required dependencies, and simply run:

```bash
./deploy.sh -k <Your Phalcon Access Key>
```

This will set up a new Phalcon project and deploy all challenges (except `start.exe` and `greedy-sad-man`) for you.

> Note: The *Access Key* used in the deploy script can be found in the [Account Settings](https://docs.blocksec.com/phalcon/quick-start/platform#account-settings) of the [Phalcon Dashboard](https://docs.blocksec.com/phalcon/quick-start/platform).

If you want to create a fork in an existing project, add the `-p` option with your *Project ID*:

```bash
./deploy.sh -k <Your Phalcon Access Key> -p <Your Phalcon Project ID>
```

> Note: The *Project ID* can be viewed in the [Project Settings](https://docs.blocksec.com/phalcon/quick-start/platform#project-settings).

To deploy a specific challenge (except `start.exe` and `greedy-sad-man`), just add the challenge name after the command, like this:

```bash
./deploy.sh -k <Your Phalcon Acess Key> <challenge>
```

### Solve

Since the official solution is provided, we will use the `Solve.s.sol` under the `challenge/project/script` directory of each challenge.

```bash
./solve.sh -f <Your Phalcon Fork RPC> <challenge>
```

> Note: The *Fork RPC* is shown in the [Fork Panel](https://docs.blocksec.com/phalcon/quick-start/fork).

When the `CHALLENGE` environment variable is provided, the script will interpret the contents of the specified file as the **contract address** for the challenge. Or else, it will resort to the defualt path.

## Acknowledgement

Great thanks to [OpenZeppelin](https://twitter.com/OpenZeppelin) for hosting such a high-quality competition and to all fellows behind [Foundry](https://github.com/foundry-rs/foundry) for building the powerful toolkit.

This repository is forked from [Ethernaut CTF 2024 Challenges & Solutions](https://github.com/OpenZeppelin/ctf-2024), where you can find the challenges with their corresponding solutions.