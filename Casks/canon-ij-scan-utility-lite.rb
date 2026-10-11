cask "canon-ij-scan-utility-lite" do
  version "4.2.1,18"
  sha256 "8e072643503e0e86e5fa046b4bcf622fa33dfb7c701b030989e6616b16593bfa"

  url "https://gdlp01.c-wss.com/gds/7/0200005317/#{version.csv.second}/msul-mac-#{version.csv.first.dots_to_underscores}-ea21_3.dmg"
  name "Canon IJ Scan Utility Lite"
  desc "Scan photos and documents with Canon inkjet devices"
  homepage "https://asia.canon/en/support/0200531730/"

  livecheck do
    url :homepage
    regex(/IJ\s+Scan\s+Utility\s+Lite\s+Ver\.?\s*(\d+(?:\.\d+)+)\s+\(Mac\)/i)
    strategy :page_match do |page, regex|
      version = page[regex, 1]
      id = page[%r{WWUFORedirectTarget\.do\?id=([A-Za-z0-9+/=]+)}i, 1]
      next if version.blank? || id.blank?

      # The id is the base64-encoded content id; its last two digits are the URL revision
      "#{version},#{id.unpack1("m")[-2..]}"
    end
  end

  depends_on :macos

  pkg "IJ Scan Utility Lite_#{version.csv.first.split(".").map { |part| part.rjust(2, "0") }.join}.pkg"

  uninstall quit:    [
              "jp.co.canon.ij.scanutilitylite",
              "jp.co.canon.ij.scanutilitylite.CIJSULAgent",
            ],
            pkgutil: [
              "jp.co.canon.pkg.ijscanutilitylite.*",
              "jp.co.canon.pkg.ijscanutilityLite.*",
            ],
            rmdir:   [
              "/Applications/Canon Utilities",
              "/Applications/Canon Utilities/IJ Scan Utility",
              "/Library/Application Support/Canon",
              "/Library/Application Support/Canon/IJ Scan Utility Lite",
            ]

  zap trash: [
    "~/Library/Application Scripts/jp.co.canon.ij.scanutilitylite",
    "~/Library/Application Scripts/jp.co.canon.ij.scanutilitylite.CIJSULAgent",
    "~/Library/Containers/jp.co.canon.ij.scanutilitylite",
    "~/Library/Containers/jp.co.canon.ij.scanutilitylite.CIJSULAgent",
  ]
end
