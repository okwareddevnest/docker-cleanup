# Makefile for docker-cleanup package
# This Makefile handles building the .deb package and repository management

VERSION := 1.0.0
PACKAGE_NAME := docker-cleanup
ARCH := all
REPO_DIR := repo
GPG_KEY_ID := your-gpg-key-id

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
	mkdir -p $(REPO_DIR)/conf
	mkdir -p $(REPO_DIR)/incoming
	mkdir -p $(REPO_DIR)/pool

	echo "Codename: stable" > $(REPO_DIR)/conf/distributions
	echo "Components: main" >> $(REPO_DIR)/conf/distributions
	echo "Architectures: all" >> $(REPO_DIR)/conf/distributions
	echo "SignWith: $(GPG_KEY_ID)" >> $(REPO_DIR)/conf/distributions

publish: build setup-repo
	mv $(PACKAGE_NAME)-$(VERSION).deb $(REPO_DIR)/incoming/
	cd $(REPO_DIR) && reprepro processincoming stable
	cd $(REPO_DIR) && reprepro export stable
	cd $(REPO_DIR) && gpg --armor --detach-sign -o dists/stable/Release.gpg dists/stable/Release

generate-key:
	gpg --full-generate-key
	gpg --list-secret-keys --keyid-format LONG 