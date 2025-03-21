# Docker Cleanup Package

A Debian package that provides an interactive Docker cleanup utility with configurable schedules and cleanup options. This package installs a systemd timer that runs according to your preferences to maintain system cleanliness.

## Features

- 🎨 Beautiful interactive terminal interface with emojis and colors
- ⏰ Configurable cleanup schedules (daily, weekly, monthly, or custom)
- 🗑️ Flexible cleanup options:
  - Clean all containers
  - Clean only stopped containers
  - Clean containers older than X days
- 🔄 Automated periodic cleanup
- 📝 Detailed logging with timestamps
- ⚙️ Easy configuration through interactive menu

## Installation

### Adding the Repository

1. Add the GPG key:
```bash
curl -fsSL https://your-repository-url/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-cleanup-archive-keyring.gpg
```

2. Add the repository to your sources:
```bash
echo "deb [signed-by=/usr/share/keyrings/docker-cleanup-archive-keyring.gpg] https://your-repository-url stable main" | sudo tee /etc/apt/sources.list.d/docker-cleanup.list
```

3. Update package lists:
```bash
sudo apt-get update
```

4. Install the package:
```bash
sudo apt-get install docker-cleanup
```

## Usage

After installation, you can configure the cleanup settings using the interactive configuration tool:

```bash
docker-cleanup-config
```

The configuration tool provides a menu-driven interface where you can:
1. Configure the cleanup schedule
2. Set cleanup options (all containers, stopped only, or by age)
3. View current settings
4. Run cleanup manually
5. Exit the configuration tool

### Schedule Options
- Daily cleanup
- Weekly cleanup
- Monthly cleanup
- Custom interval (in days)

### Cleanup Options
- Clean all containers
- Clean only stopped containers
- Clean containers older than X days

### Manual Cleanup
You can trigger a cleanup manually at any time:
```bash
sudo systemctl start docker-cleanup.service
```

## Logs

Cleanup activities are logged to the system journal. View logs with:
```bash
journalctl -u docker-cleanup.service
```

## Building from Source

1. Install build dependencies:
```bash
sudo apt-get install build-essential dpkg-dev reprepro gnupg
```

2. Generate GPG key (if not already done):
```bash
make generate-key
```

3. Update the GPG key ID in the Makefile

4. Build the package:
```bash
make build
```

5. Set up and publish to repository:
```bash
make publish
```

## Package Structure

- `/usr/local/bin/docker-cleanup.sh`: Main cleanup script
- `/usr/local/bin/docker-cleanup-config`: Interactive configuration tool
- `/etc/systemd/system/docker-cleanup.service`: Systemd service unit
- `/etc/systemd/system/docker-cleanup.timer`: Systemd timer unit
- `/etc/docker-cleanup.conf`: Configuration file

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 