#!/bin/bash

set -e  # Exit immediately if a command fails

# Define project and registry
PROJECT_NAME="my-npm-project"
REGISTRY_URL="https://packages.buildkite.com/packages-sandbox/is-that-you-nan/npm/"

echo "🚀 Setting up npm project in '$PROJECT_NAME' using registry: $REGISTRY_URL"
echo "------------------------------------------------------------"

# Step 1: Create a new project directory
if [ -d "$PROJECT_NAME" ]; then
    echo "⚠️  Project directory '$PROJECT_NAME' already exists. Removing it..."
    rm -rf "$PROJECT_NAME"
fi

mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME"
echo "✅ Created project directory: $PROJECT_NAME"

# Step 2: Initialize an npm project
echo "📦 Initializing npm project..."
npm init -y >/dev/null 2>&1
echo "✅ npm project initialized."

# Step 3: Configure npm to use the private registry
echo "🔧 Setting npm registry to: $REGISTRY_URL"
echo "registry=$REGISTRY_URL" > .npmrc
echo "✅ npm registry configured."

# Step 4: Install lodash from the private registry
echo "📥 Installing lodash from private registry..."
npm install lodash --registry="$REGISTRY_URL"

# Check if installation succeeded
if [ $? -eq 0 ]; then
    echo "✅ lodash successfully installed from $REGISTRY_URL"
else
    echo "❌ Error installing lodash. Check your registry and try again."
    exit 1
fi

# Step 5: Create index.js with a simple lodash example
echo "📝 Creating 'index.js' with a simple lodash example..."
cat <<EOL > index.js
const _ = require('lodash');

// Generate an array of 10 random numbers
const numbers = [42, 7, 88, 3, 16, 24, 91, 5, 33, 76];

console.log("🔀 Original mixed array:", numbers);

// Sort the array using lodash
const sortedNumbers = _.sortBy(numbers);

console.log("✅ Sorted numbers:", sortedNumbers);
EOL
echo "✅ index.js created."

# Step 6: Run the JavaScript script
echo "🚀 Running 'index.js'..."
node index.js

# Step 7: Verify installed packages
echo "🔍 Installed packages:"
npm list --depth=0

# Step 8: Verify registry configuration
echo "🔍 Checking npm registry configuration..."
CURRENT_REGISTRY=$(npm config get registry)
echo "🛠️  Current registry: $CURRENT_REGISTRY"

if [ "$CURRENT_REGISTRY" == "$REGISTRY_URL" ]; then
    echo "✅ Registry is correctly set to $REGISTRY_URL"
else
    echo "❌ Warning: Registry is not set correctly!"
    exit 1
fi

echo "🎉 Setup complete! Your npm project is ready."
echo "------------------------------------------------------------"
