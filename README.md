# Config
> Configs for my workstations / servers using `nixos`, `nix-darwin` and `home-manager`. 

## Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [Nix](https://nixos.org/download.html)

## Background

| Host name      | Usage                              | Tools                      | Progress |
| :------------- | :--------------------------------: | :------------------------: | :------: |
| gaia           | macos m1 (personal) workstation    | nix-darwin / home-manager  | ✅ |
| demeter        | macos intel (personal) workstation | nix-darwin / home-manager  | ✅ |
| aether         | macos intel (work) workstation     | nix-darwin / home-manager  | ✅ |
| infinity       | vm developer workstation           | nixos / home-manager       | 🚧 |
| kubix          | nextcloud server                   | nixos                      | 🚧 | 

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

To deploy changes to `demeter`, run the following command:
```bash
make deploy_demeter
```

To deploy changes to `aether`, run the following command:
```bash
make deploy_aether
```

To deploy changes to `infinity`, run the following command:
```bash
make deploy_infinity
```

To reload with local changes, run the following command:
```bash
make reload
```
