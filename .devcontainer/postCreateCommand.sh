#!/bin/bash
set -e

echo "🚀 Initializing AIandI Operations Center..."

echo "📦 Installing Doppler CLI..."
(curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key | sudo apt-key add -)
echo "deb https://packages.doppler.com/public/cli/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/doppler-cli.list
sudo apt-get update && sudo apt-get install -y doppler

echo "-----------------------------------------------------------------"
echo "⚠️  ACTION REQUIRED: Link your Private Second Brain"
echo "-----------------------------------------------------------------"
echo "Because you granted Codespaces access to your other repositories,"
echo "you can now clone your private data repo without extra authentication."
echo ""
echo "Run the following commands to link your data:"
echo ""
echo "    # Replace <your-username> with your GitHub handle"
echo "    gh repo clone <your-username>/AIandI-userdata ./AIandI-userdata"
echo "    export USERDATA_REPO=./AIandI-userdata"
echo "    ./infrastructure/scripts/link_userdata.sh"
echo "-----------------------------------------------------------------"

echo "✅ Environment initialization script finished."