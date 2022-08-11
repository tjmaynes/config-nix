# Kratos
> Configuration files and automation scripts for my home server setup.

| Program                                                    | Usage                              | Tools                      | Status |
| :--------------------------------------------------------- | :--------------------------------: | :------------------------: | :----: |
| [plex-server](https://hub.docker.com/r/plexinc/pms-docker) | media server                       | docker-compose             | ✅ |
| [home-assistant-web](https://gogs.io/)                     | home automation server             | docker-compose             | ✅ |
| [calibre-web](https://github.com/janeczku/calibre-web)     | web-based ebook-reader             | docker-compose             | ✅ |
| [gogs-web](https://gogs.io/)                               | git server / mirror                | docker-compose             | ✅ |

## Requirements

- [GNU Make](https://www.gnu.org/software/make/)
- [Docker](https://www.docker.com/#)

## Usage
To install the home server, run the following command:
```bash
./scripts/install.sh "<some-base-directory>" "<some-plex-claim-token>"
```

To uninstall the home server, run the following command:
```bash
./scripts/uninstall.sh "<some-base-directory>"
```
