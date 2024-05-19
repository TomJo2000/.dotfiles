#!/usr/bin/env bash

# Assign XDG_DATA_DIR and FONT_DIR unless already assigned
: "${XDG_DATA_HOME:="${HOME}/.local/share"}"
: "${FONT_DIR:="${XDG_DATA_HOME}/fonts"}"

# Grab the latest Tag and its SHA256
read -r sha tag_name < <(git ls-remote --refs --tags "https://github.com/ryanoasis/nerd-fonts/" | tail -n1)
printf '%s\n' "Latest tag: ${tag_name##*\/} $sha"

# Check for and make the FONT_DIR if it doesn't exist
[[ -d "${FONT_DIR}"         ]] || mkdir "${FONT_DIR}"
[[ -d "${FONT_DIR}/Hasklig" ]] || mkdir "${FONT_DIR}/Hasklig/"

# Download the Regular, Italic, Bold and BoldItalic version of the font.
for variant in 'Regular' 'Italic' 'Bold' 'Bold-Italic'; do
    echo     "https://github.com/ryanoasis/nerd-fonts/raw/${sha}/patched-fonts/Hasklig/${variant}/HasklugNerdFontMono-${variant//-/}.otf"
    curl -fL "https://github.com/ryanoasis/nerd-fonts/raw/${sha}/patched-fonts/Hasklig/${variant}/HasklugNerdFontMono-${variant//-/}.otf" \
    -o "${FONT_DIR}/Hasklig/HaskligNFM_${variant//-/}.otf"
done

# Output the full font names, and versions then add them to the font cache
fc-query -f '%{fullname}@%{fontversion}\n' "${XDG_DATA_HOME}/fonts/Hasklig/HaskligNFM_"{Regular,Italic,Bold,BoldItalic}".otf"
fc-cache -v "${FONT_DIR}"
