cask "macterm" do
  version "1.23.4"
  sha256 "6c77262683f7f5043bb70dec0831b72b836206f45983d43f833b2dbd9c40b52e"

  url "https://github.com/thdxg/macterm/releases/download/v#{version}/Macterm-#{version}.dmg"
  name "Macterm"
  desc "Native terminal built with SwiftUI and libghostty"
  homepage "https://github.com/thdxg/macterm"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

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
