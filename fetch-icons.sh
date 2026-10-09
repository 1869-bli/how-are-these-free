#!/usr/bin/env bash
# Fetches a logo for each program into ./images/.
# Tries Simple Icons first (crisp SVG), then falls back to the site's favicon.
# Re-run any time; drop your own images/<slug>.svg (or .png) to override.
set -u
cd "$(dirname "$0")"
mkdir -p images

UA="Mozilla/5.0 (X11; Linux x86_64) icon-fetcher"

# slug | simpleicons-slug (or -) | domain (or -)
entries=$(cat <<'EOF'
linux|linux|kernel.org
openbsd|openbsd|openbsd.org
reactos|reactos|reactos.org
darwin|apple|opensource.apple.com
freebsd|freebsd|freebsd.org
kde-plasma|kde|kde.org
gnome|gnome|gnome.org
budgie|-|buddiesofbudgie.org
haiku|haiku|haiku-os.org
serenityos|-|serenityos.org
steamos|steam|steampowered.com
wine|wine|winehq.org
proton|-|-
xenia|-|xenia.jp
rpcs3|-|rpcs3.net
dxvk|-|-
vkd3d-proton|-|-
blender|blender|blender.org
photopea|photopea|photopea.com
davinci-resolve|davinciresolve|blackmagicdesign.com
garageband|-|apple.com
lmms|lmms|lmms.io
shotcut|-|shotcut.org
kdenlive|kdenlive|kdenlive.org
gimp|gimp|gimp.org
audacity|audacity|audacityteam.org
krita|krita|krita.org
kicad|kicad|kicad.org
freecad|freecad|freecad.org
c|c|-
cplusplus|cplusplus|isocpp.org
python|python|python.org
csharp|dotnet|dotnet.microsoft.com
javascript|javascript|developer.mozilla.org
html|html5|developer.mozilla.org
java|openjdk|openjdk.org
rust|rust|rust-lang.org
unreal-engine|unrealengine|unrealengine.com
visual-studio-community|visualstudio|visualstudio.microsoft.com
godot|godotengine|godotengine.org
flightgear|-|flightgear.org
vulkan|vulkan|vulkan.org
opengl|opengl|opengl.org
internet-archive|internetarchive|archive.org
wayback-machine|-|web.archive.org
openstreetmap|openstreetmap|openstreetmap.org
vlc|vlcmediaplayer|videolan.org
7zip|7zip|7-zip.org
ffmpeg|ffmpeg|ffmpeg.org
sqlite|sqlite|sqlite.org
chromium|chromium|chromium.org
vivaldi|vivaldi|vivaldi.com
epic-games-launcher|epicgames|epicgames.com
gog-galaxy|gogdotcom|gog.com
EOF
)

while IFS='|' read -r slug icon domain; do
  [ -z "$slug" ] && continue
  out=""
  if [ "$icon" != "-" ]; then
    f="images/$slug.svg"
    ct=$(curl -sL --max-time 25 -A "$UA" -o "$f" -w '%{http_code} %{content_type}' "https://cdn.simpleicons.org/$icon")
    if [ "${ct%% *}" = "200" ] && [ "${ct#* }" = "image/svg+xml" ]; then
      out="svg (simpleicons:$icon)"
    else
      rm -f "$f"
    fi
  fi
  if [ -z "$out" ] && [ "$domain" != "-" ]; then
    f="images/$slug.png"
    ct=$(curl -sL --max-time 25 -A "$UA" -o "$f" -w '%{http_code} %{content_type}' "https://www.google.com/s2/favicons?domain=$domain&sz=128")
    if [ "${ct%% *}" = "200" ] && [[ "${ct#* }" == image/* ]]; then
      out="png (favicon:$domain)"
    else
      rm -f "$f"
    fi
  fi
  if [ -n "$out" ]; then
    printf '  ok   %-24s %s\n' "$slug" "$out"
  else
    printf '  MISS %-24s\n' "$slug"
  fi
done <<< "$entries"

echo
echo "Done. $(ls images | wc -l) files in images/"
