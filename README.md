# Config
> Configs for my workstations / servers using `nixos`, `nix-darwin` and `home-manager`. 

## Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [Nix](https://nixos.org/download.html)

## Background

| Host name                                                  | Usage                              | Tools                      | Progress |
| :--------------------------------------------------------- | :--------------------------------: | :------------------------: | :------: |
| [gaia](https://en.wikipedia.org/wiki/Gaia)                 | macos m1 (personal) workstation    | nix-darwin / home-manager  | ✅ |
| [demeter](https://en.wikipedia.org/wiki/Demeter)           | macos intel (personal) workstation | nix-darwin / home-manager  | ✅ |
| [aether](https://en.wikipedia.org/wiki/Aether_(mythology)) | macos intel (work) workstation     | nix-darwin / home-manager  | ✅ |
| [glaucus](https://en.wikipedia.org/wiki/Glaucus)           | vm developer workstation           | nixos / home-manager       | ✅ |
| [atlas](https://en.wikipedia.org/wiki/Argo)                | server                             | nixos                      | 🚧 |

## Usage
> *For MacOS Users on Apple Silicon Chips*:
> Before installing `gaia`, please run the following command to install `rosetta2` which is needed for the `nix-darwin` installation:
> ```bash
> softwareupdate --install-rosetta --agree-to-license
> ```

To install `gaia` on an M1 Mac, run the following command:
```bash
make install_gaia
```

To install `demeter` on an Intel Mac, run the following command:
```bash
make install_demeter
```

To install `aether` on an Intel Mac, run the following command:
```bash
make install_aether
```

To install `glaucus` on VMware Fusion, run the following command:
```bash
make install_glaucus
```

To install `atlas`, run the following command:
```bash
make install_atlas
```

To reload local changes, run the following command:
```bash
make reload
```

## Notes

I learned quite a bit of Nixos-specific concepts from Malloc47's [config repo](https://github.com/malloc47/config).
