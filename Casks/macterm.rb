cask "macterm" do
  version "1.10.3"
  sha256 "609cd6847024b4a546749583ea3aec19da841a7370365539d9cb6eb7a6e67f25"

  url "https://github.com/thdxg/macterm/releases/download/v#{version}/Macterm-#{version}.dmg"
  name "Macterm"
  desc "Native terminal built with SwiftUI and libghostty"
  homepage "https://github.com/thdxg/macterm"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :tahoe"

  app "Macterm.app"

  # Macterm is ad-hoc signed (no Developer ID, not notarized). Without stripping
  # the quarantine xattr, first launch hits a Gatekeeper block that requires a
  # right-click → Open. Sparkle auto-updates after install bypass Gatekeeper
  # because they're verified against an EdDSA signature baked into the app.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Macterm.app"],
                   sudo: false
  end

  zap trash: [
    "~/.config/Macterm",
    "~/Library/Application Support/Macterm",
    "~/Library/Caches/com.thdxg.macterm",
    "~/Library/Caches/com.thdxg.macterm.ShipIt",
    "~/Library/Preferences/com.thdxg.macterm.plist",
  ]
end
