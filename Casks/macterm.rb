cask "macterm" do
  version "1.18.2"
  sha256 "96918b3e256c166dcc092a17895e31cdb2832b33768c22f32954a3f0e6530d68"

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
