# Docker Cleanup 🐳

An interactive Docker cleanup utility that helps you maintain your system by automatically cleaning up unused Docker containers and resources.

## Features 🌟

- 🎨 Beautiful interactive terminal interface with emojis and colors
- ⏰ Configurable cleanup schedules (daily, weekly, monthly, or custom)
- 🗑️ Flexible cleanup options:
  - Clean all containers
  - Clean only stopped containers
  - Clean containers older than X days
- 🔄 Automated periodic cleanup
- 📝 Detailed logging with timestamps
- ⚙️ Easy configuration through interactive menu

## Installation 📦

See [INSTALL.md](INSTALL.md) for detailed installation instructions.

Quick install:

```bash
# Add GPG key
curl -fsSL https://raw.githubusercontent.com/okwareddevnest/docker-cleanup/main/docker-cleanup.gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-cleanup-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/docker-cleanup-archive-keyring.gpg] https://raw.githubusercontent.com/okwareddevnest/docker-cleanup/main/repo stable main" | sudo tee /etc/apt/sources.list.d/docker-cleanup.list

# Update and install
sudo apt-get update
sudo apt-get install docker-cleanup
```

## Usage 🚀

1. Configure cleanup settings:
```bash
docker-cleanup-config
```

2. View current status:
```bash
systemctl status docker-cleanup.timer
```

3. View cleanup logs:
```bash
journalctl -u docker-cleanup.service
```

## Configuration Options ⚙️

The interactive configuration tool (`docker-cleanup-config`) provides:

1. Schedule Configuration:
   - Daily cleanup
   - Weekly cleanup
   - Monthly cleanup
   - Custom interval (in days)

2. Cleanup Options:
   - Clean all containers
   - Clean only stopped containers
   - Clean containers older than X days

3. Additional Features:
   - View current settings
   - Run cleanup manually
   - Monitor cleanup logs

## Building from Source 🛠️

1. Clone the repository:
```bash
git clone https://github.com/okwareddevnest/docker-cleanup.git
cd docker-cleanup
```

2. Build the package:
```bash
make build
```

3. Install locally:
```bash
sudo dpkg -i docker-cleanup-1.0.0.deb
sudo apt-get install -f
```

## Contributing 🤝

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Author ✍️

Dedan Okware ([@okwareddevnest](https://github.com/okwareddevnest))

## Support 💬

If you encounter any issues or have questions, please [open an issue](https://github.com/okwareddevnest/docker-cleanup/issues). 