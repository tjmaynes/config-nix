# Kratos
> Configuration files and automation scripts for my home server setup.

| Program                                                    | Usage                              | Tools                      | Status |
| :--------------------------------------------------------- | :--------------------------------: | :------------------------: | :----: |
| [jellyfin](https://jellyfin.org/)                          | media server                       | docker-compose             | ✅ |
| [home-assistant](https://www.home-assistant.io/)           | home automation server             | docker-compose             | ✅ |
| [calibre-web](https://github.com/janeczku/calibre-web)     | web-based ebook-reader             | docker-compose             | ✅ |
| [gogs](https://gogs.io/)                                   | git server / mirror                | docker-compose             | ✅ |
| [homer](https://github.com/bastienwirtz/homer)             | start-page                         | docker-compose             | ✅ |
| [tailscale-agent](https://tailscale.com/)                  | vpn provider                       | docker-compose             | ✅ |
| [audiobookshelf](https://www.audiobookshelf.org/)          | podcast & audiobooks server        | docker-compose             | ✅ |
| [podgrab](https://github.com/akhilrex/podgrab)             | podcast downloader                 | docker-compose             | ✅ |

## Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [Docker](https://www.docker.com/#)

## Usage
To install the home server, run the following command:
```bash
./scripts/install.sh "<some-base-directory>"
```

To uninstall the home server, run the following command:
```bash
./scripts/uninstall.sh "<some-base-directory>"
```
