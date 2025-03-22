# Makefile for docker-cleanup package
# This Makefile handles building the .deb package and repository management

# Version and package info
PACKAGE_NAME=docker-cleanup
VERSION=1.0.0
ARCH=amd64
PACKAGE=$(PACKAGE_NAME)-$(VERSION)
DEB_FILE=$(PACKAGE).deb

# Repository info
REPO_DIR=repo
GPG_KEY_ID=0x1234567890ABCDEF

# Build targets
.PHONY: all clean build publish release

all: build

clean:
	rm -rf $(PACKAGE)
	rm -f $(DEB_FILE)

build: clean
	mkdir -p $(PACKAGE)/usr/local/bin
	mkdir -p $(PACKAGE)/etc/systemd/system
	mkdir -p $(PACKAGE)/etc
	mkdir -p $(PACKAGE)/DEBIAN
	cp docker-cleanup.sh $(PACKAGE)/usr/local/bin/
	cp docker-cleanup-config $(PACKAGE)/usr/local/bin/
	cp docker-cleanup.service $(PACKAGE)/etc/systemd/system/
	cp docker-cleanup.timer $(PACKAGE)/etc/systemd/system/
	cp docker-cleanup.conf $(PACKAGE)/etc/
	cp DEBIAN/* $(PACKAGE)/DEBIAN/
	chmod 755 $(PACKAGE)/DEBIAN/postinst
	chmod 755 $(PACKAGE)/DEBIAN/prerm
	chmod 644 $(PACKAGE)/etc/docker-cleanup.conf
	dpkg-deb --build $(PACKAGE)

# Repository setup
setup-repo:
	mkdir -p $(REPO_DIR)/conf
	mkdir -p $(REPO_DIR)/dists/stable/main/binary-$(ARCH)
	mkdir -p $(REPO_DIR)/pool/main/d/$(PACKAGE_NAME)
	mkdir -p $(REPO_DIR)/tmp
	echo "Origin: Docker Cleanup" > $(REPO_DIR)/conf/distributions
	echo "Label: Docker Cleanup" >> $(REPO_DIR)/conf/distributions
	echo "Codename: stable" >> $(REPO_DIR)/conf/distributions
	echo "Version: 1.0" >> $(REPO_DIR)/conf/distributions
	echo "Architectures: $(ARCH)" >> $(REPO_DIR)/conf/distributions
	echo "Components: main" >> $(REPO_DIR)/conf/distributions
	echo "Description: Docker Cleanup Repository" >> $(REPO_DIR)/conf/distributions
	echo "SignWith: $(GPG_KEY_ID)" >> $(REPO_DIR)/conf/distributions
	echo "Name: default" > $(REPO_DIR)/conf/incoming
	echo "IncomingDir: incoming" >> $(REPO_DIR)/conf/incoming
	echo "TempDir: tmp" >> $(REPO_DIR)/conf/incoming
	echo "Allow: stable" >> $(REPO_DIR)/conf/incoming
	echo "Cleanup: on_deny on_error" >> $(REPO_DIR)/conf/incoming

# Export GPG key
export-key:
	gpg --armor --export $(GPG_KEY_ID) > docker-cleanup.gpg

# Publish package to repository
publish: build
	@echo "Publishing package to repository..."
	@mkdir -p $(REPO_DIR)/conf
	@mkdir -p $(REPO_DIR)/dists/stable/main/binary-$(ARCH)
	@mkdir -p $(REPO_DIR)/pool/main/d/$(PACKAGE_NAME)
	@mkdir -p $(REPO_DIR)/tmp
	@echo "Origin: Docker Cleanup" > $(REPO_DIR)/conf/distributions
	@echo "Label: Docker Cleanup" >> $(REPO_DIR)/conf/distributions
	@echo "Codename: stable" >> $(REPO_DIR)/conf/distributions
	@echo "Version: 1.0" >> $(REPO_DIR)/conf/distributions
	@echo "Architectures: $(ARCH)" >> $(REPO_DIR)/conf/distributions
	@echo "Components: main" >> $(REPO_DIR)/conf/distributions
	@echo "Description: Docker Cleanup Repository" >> $(REPO_DIR)/conf/distributions
	@echo "SignWith: $(GPG_KEY_ID)" >> $(REPO_DIR)/conf/distributions
	@echo "Name: default" > $(REPO_DIR)/conf/incoming
	@echo "IncomingDir: incoming" >> $(REPO_DIR)/conf/incoming
	@echo "TempDir: tmp" >> $(REPO_DIR)/conf/incoming
	@echo "Allow: stable" >> $(REPO_DIR)/conf/incoming
	@echo "Cleanup: on_deny on_error" >> $(REPO_DIR)/conf/incoming
	@cp $(DEB_FILE) $(REPO_DIR)/pool/main/d/$(PACKAGE_NAME)/
	@cd $(REPO_DIR) && dpkg-scanpackages pool/main/d/$(PACKAGE_NAME) > dists/stable/main/binary-$(ARCH)/Packages
	@cd $(REPO_DIR) && rm -f dists/stable/main/binary-$(ARCH)/Packages.gz
	@cd $(REPO_DIR) && gzip -k dists/stable/main/binary-$(ARCH)/Packages
	@cd $(REPO_DIR) && apt-ftparchive release dists/stable > dists/stable/Release
	@cd $(REPO_DIR) && gpg --armor --detach-sign -o dists/stable/Release.gpg dists/stable/Release
	@cd $(REPO_DIR) && gpg --clearsign -o dists/stable/InRelease dists/stable/Release
	@echo "Package published successfully!"

# Release management
.PHONY: release-major release-minor release-patch

release-major:
	./scripts/release.sh major

release-minor:
	./scripts/release.sh minor

release-patch:
	./scripts/release.sh patch

# Generate installation instructions
install-instructions:
	@echo "# Installation Instructions for Docker Cleanup" > INSTALL.md
	@echo "" >> INSTALL.md
	@echo "## Prerequisites" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "- Docker installed and running" >> INSTALL.md
	@echo "- sudo privileges" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "## Installation Steps" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "1. Add the GPG key:" >> INSTALL.md
	@echo "\`\`\`bash" >> INSTALL.md
	@echo "curl -fsSL https://raw.githubusercontent.com/okwareddevnest/docker-cleanup/main/docker-cleanup.gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-cleanup-archive-keyring.gpg" >> INSTALL.md
	@echo "\`\`\`" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "2. Add the repository:" >> INSTALL.md
	@echo "\`\`\`bash" >> INSTALL.md
	@echo "echo \"deb [signed-by=/usr/share/keyrings/docker-cleanup-archive-keyring.gpg] https://raw.githubusercontent.com/okwareddevnest/docker-cleanup/main/repo stable main\" | sudo tee /etc/apt/sources.list.d/docker-cleanup.list" >> INSTALL.md
	@echo "\`\`\`" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "3. Update package lists:" >> INSTALL.md
	@echo "\`\`\`bash" >> INSTALL.md
	@echo "sudo apt-get update" >> INSTALL.md
	@echo "\`\`\`" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "4. Install the package:" >> INSTALL.md
	@echo "\`\`\`bash" >> INSTALL.md
	@echo "sudo apt-get install docker-cleanup" >> INSTALL.md
	@echo "\`\`\`" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "## Usage" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "1. Configure cleanup settings:" >> INSTALL.md
	@echo "\`\`\`bash" >> INSTALL.md
	@echo "sudo docker-cleanup-config" >> INSTALL.md
	@echo "\`\`\`" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "2. View current status:" >> INSTALL.md
	@echo "\`\`\`bash" >> INSTALL.md
	@echo "sudo systemctl status docker-cleanup.timer" >> INSTALL.md
	@echo "\`\`\`" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "3. Check cleanup logs:" >> INSTALL.md
	@echo "\`\`\`bash" >> INSTALL.md
	@echo "sudo journalctl -u docker-cleanup.service" >> INSTALL.md
	@echo "\`\`\`" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "## Uninstallation" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "1. Remove the package:" >> INSTALL.md
	@echo "\`\`\`bash" >> INSTALL.md
	@echo "sudo apt-get remove docker-cleanup" >> INSTALL.md
	@echo "\`\`\`" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "2. Remove the repository:" >> INSTALL.md
	@echo "\`\`\`bash" >> INSTALL.md
	@echo "sudo rm /etc/apt/sources.list.d/docker-cleanup.list" >> INSTALL.md
	@echo "\`\`\`" >> INSTALL.md 