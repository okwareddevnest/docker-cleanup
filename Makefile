# Makefile for docker-cleanup package
# This Makefile handles building the .deb package and repository management

VERSION := 1.0.0
PACKAGE_NAME := docker-cleanup
ARCH := amd64
REPO_DIR := repo
GPG_KEY_ID := 11D3D06C5893282ACA075D8C41AACBF24D5D0C96

.PHONY: all build clean publish setup-repo

all: build

build: clean
	mkdir -p $(PACKAGE_NAME)-$(VERSION)/usr/local/bin
	mkdir -p $(PACKAGE_NAME)-$(VERSION)/etc/systemd/system
	mkdir -p $(PACKAGE_NAME)-$(VERSION)/etc
	mkdir -p $(PACKAGE_NAME)-$(VERSION)/DEBIAN
	cp docker-cleanup.sh $(PACKAGE_NAME)-$(VERSION)/usr/local/bin/
	cp docker-cleanup-config $(PACKAGE_NAME)-$(VERSION)/usr/local/bin/
	cp docker-cleanup.service $(PACKAGE_NAME)-$(VERSION)/etc/systemd/system/
	cp docker-cleanup.timer $(PACKAGE_NAME)-$(VERSION)/etc/systemd/system/
	cp docker-cleanup.conf $(PACKAGE_NAME)-$(VERSION)/etc/
	cp DEBIAN/* $(PACKAGE_NAME)-$(VERSION)/DEBIAN/
	chmod 755 $(PACKAGE_NAME)-$(VERSION)/DEBIAN/postinst
	chmod 755 $(PACKAGE_NAME)-$(VERSION)/DEBIAN/prerm
	chmod 644 $(PACKAGE_NAME)-$(VERSION)/etc/docker-cleanup.conf
	dpkg-deb --build $(PACKAGE_NAME)-$(VERSION)

clean:
	rm -rf $(PACKAGE_NAME)-$(VERSION)
	rm -f $(PACKAGE_NAME)-$(VERSION).deb

setup-repo:
	mkdir -p $(REPO_DIR)/dists/stable/main/binary-amd64
	mkdir -p $(REPO_DIR)/pool/main/d/$(PACKAGE_NAME)

publish: build setup-repo
	cp $(PACKAGE_NAME)-$(VERSION).deb $(REPO_DIR)/pool/main/d/$(PACKAGE_NAME)/
	cd $(REPO_DIR) && dpkg-scanpackages pool/main/d/$(PACKAGE_NAME) > dists/stable/main/binary-amd64/Packages
	cd $(REPO_DIR) && gzip -k dists/stable/main/binary-amd64/Packages
	cd $(REPO_DIR) && apt-ftparchive release dists/stable > dists/stable/Release
	cd $(REPO_DIR) && gpg --armor --detach-sign -o dists/stable/Release.gpg dists/stable/Release
	cd $(REPO_DIR) && gpg --armor --output dists/stable/InRelease --clearsign dists/stable/Release

generate-key:
	gpg --full-generate-key
	gpg --list-secret-keys --keyid-format LONG

export-key:
	gpg --armor --export $(GPG_KEY_ID) > docker-cleanup.gpg

# Create installation instructions
install-instructions:
	@echo "To install docker-cleanup, follow these steps:" > INSTALL.md
	@echo "" >> INSTALL.md
	@echo "1. Add the GPG key:" >> INSTALL.md
	@echo "```bash" >> INSTALL.md
	@echo "curl -fsSL https://raw.githubusercontent.com/dedanokware/docker-cleanup/main/docker-cleanup.gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-cleanup-archive-keyring.gpg" >> INSTALL.md
	@echo "```" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "2. Add the repository:" >> INSTALL.md
	@echo "```bash" >> INSTALL.md
	@echo "echo \"deb [signed-by=/usr/share/keyrings/docker-cleanup-archive-keyring.gpg] https://raw.githubusercontent.com/dedanokware/docker-cleanup/main/repo stable main\" | sudo tee /etc/apt/sources.list.d/docker-cleanup.list" >> INSTALL.md
	@echo "```" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "3. Update package lists:" >> INSTALL.md
	@echo "```bash" >> INSTALL.md
	@echo "sudo apt-get update" >> INSTALL.md
	@echo "```" >> INSTALL.md
	@echo "" >> INSTALL.md
	@echo "4. Install docker-cleanup:" >> INSTALL.md
	@echo "```bash" >> INSTALL.md
	@echo "sudo apt-get install docker-cleanup" >> INSTALL.md
	@echo "```" >> INSTALL.md 