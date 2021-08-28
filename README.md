# Config
> Configs for my workstations using `nixos`, `nix-darwin` and `home-manager`. 

## Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [Nix](https://nixos.org/download.html)

## Background

| Host name      | Usage                        | Tools                      | Progress |
| :------------- | :--------------------------: | :------------------------: | :-------: |
| gaia           | macos m1 personal (m1) workstation | nix-darwin / home-manager  | ✅ |
| aether         | macos other (intel) workstation    | nix-darwin / home-manager  | ✅ |
| infinity       | cloud developer workstation        | nixos / home-manager       | 🚧 |
| cosmos         | personal server                    | nixos                      | 🚧 |

## Usage
> *For MacOS Users on Apple Silicon Chips*:
> Before deploying `gaia`, please run the following command to install `rosetta2` which is needed for the `nix-darwin` installation:
> ```bash
> softwareupdate --install-rosetta --agree-to-license
> ```

To deploy changes to `gaia`, run the following command:
```bash
make deploy_gaia
```

To deploy changes to `aether`, run the following command:
```bash
make deploy_aether
```

To deploy changes to `cosmos`, run the following command:
```bash
make deploy_cosmos
```

To deploy changes to `infinity`, run the following command:
```bash
make deploy_infinity
```

To reload with local changes, run the following command:
```bash
make reload
```
