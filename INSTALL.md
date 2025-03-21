# Installing Docker Cleanup

To install docker-cleanup, follow these steps:

1. Add the GPG key:
```bash
curl -fsSL https://raw.githubusercontent.com/okwareddevnest/docker-cleanup/main/docker-cleanup.gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-cleanup-archive-keyring.gpg
```

2. Add the repository:
```bash
echo "deb [signed-by=/usr/share/keyrings/docker-cleanup-archive-keyring.gpg] https://raw.githubusercontent.com/okwareddevnest/docker-cleanup/main/repo stable main" | sudo tee /etc/apt/sources.list.d/docker-cleanup.list
```

3. Update package lists:
```bash
sudo apt-get update
```

4. Install docker-cleanup:
```bash
sudo apt-get install docker-cleanup
```

# Usage

After installation, you can:

1. Configure cleanup settings:
```bash
docker-cleanup-config
```

2. View the current status:
```bash
systemctl status docker-cleanup.timer
```

3. View cleanup logs:
```bash
journalctl -u docker-cleanup.service
```

The configuration tool provides an interactive interface where you can:
- Set cleanup schedule (daily, weekly, monthly, or custom)
- Choose which containers to clean up
- View current settings
- Run cleanup manually

# Uninstallation

To uninstall docker-cleanup:

```bash
sudo apt-get remove docker-cleanup
```

To remove the repository:
```bash
sudo rm /etc/apt/sources.list.d/docker-cleanup.list
sudo rm /usr/share/keyrings/docker-cleanup-archive-keyring.gpg
sudo apt-get update
```