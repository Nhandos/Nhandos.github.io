#!/usr/bin/env bash

set -e

# Get current datetime for front matter and filename
DATE="$(date '+%Y-%m-%d %H:%M:%S %z')"
DATE_FILE="$(date '+%Y-%m-%d')"

# Prompt until non-empty title is provided
while true; do
    read -e -p "Post title (required): " TITLE
    if [[ -n "$TITLE" ]]; then
        break
    fi
    echo "⚠️  Title cannot be empty. Please enter a title."
done

# Optional fields with hints
read -e -p "Top-level category (optional, press Enter to skip): " CATEGORY
read -e -p "Sub-category (optional, press Enter to skip): " SUBCATEGORY
read -e -p "Tags (comma-separated, optional, e.g., 'life, writing') [press Enter to skip]: " TAGS

# Slugify title for filename
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')

FILENAME="../_posts/${DATE_FILE}-${SLUG}.md"

# Format optional fields
YAML_CATEGORIES="[]"
if [[ -n "$CATEGORY" || -n "$SUBCATEGORY" ]]; then
    YAML_CATEGORIES="[${CATEGORY:-null}, ${SUBCATEGORY:-null}]"
fi

YAML_TAGS="[]"
if [[ -n "$TAGS" ]]; then
    IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
    CLEANED_TAGS=()
    for tag in "${TAG_ARRAY[@]}"; do
        CLEANED_TAGS+=("$(echo "$tag" | xargs)")  # Trim whitespace
    done
    YAML_TAGS=$(printf ", %s" "${CLEANED_TAGS[@]}")
    YAML_TAGS="[${YAML_TAGS:2}]"
fi

# Create post file with front matter
cat <<EOF > "$FILENAME"
---
title: "$TITLE"
date: $DATE
categories: $YAML_CATEGORIES
tags: $YAML_TAGS
render_with_liquid: false
---

<!-- Write your post content here -->

EOF

echo "✅ Post created: $FILENAME"

