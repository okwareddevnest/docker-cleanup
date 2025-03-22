#!/bin/bash

# Release script for docker-cleanup
# This script helps manage versions and create releases

set -e

# Function to show usage
show_usage() {
    echo "Usage: $0 [major|minor|patch]"
    echo "  major: Increment major version (X.0.0)"
    echo "  minor: Increment minor version (0.X.0)"
    echo "  patch: Increment patch version (0.0.X)"
    exit 1
}

# Function to update version in DEBIAN/control
update_version() {
    local new_version=$1
    sed -i "s/^Version: .*/Version: $new_version/" DEBIAN/control
    echo "Updated version to $new_version in DEBIAN/control"
}

# Function to get current version
get_current_version() {
    grep "^Version:" DEBIAN/control | cut -d' ' -f2
}

# Function to increment version
increment_version() {
    local version=$1
    local type=$2
    local major minor patch

    IFS='.' read -r major minor patch <<< "$version"

    case $type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            show_usage
            ;;
    esac

    echo "$major.$minor.$patch"
}

# Check if release type is provided
if [ $# -ne 1 ]; then
    show_usage
fi

# Get current version
current_version=$(get_current_version)

# Increment version
new_version=$(increment_version "$current_version" "$1")

# Update version in DEBIAN/control
update_version "$new_version"

# Create git tag
git add DEBIAN/control
git commit -m "Release version $new_version"
git tag -a "v$new_version" -m "Release version $new_version"

echo "Created release version $new_version"
echo "To push the release, run:"
echo "  git push origin main"
echo "  git push origin v$new_version" 