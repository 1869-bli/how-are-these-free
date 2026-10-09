# Icons

Each program on the page loads its logo from this folder:

```
images/<slug>.svg
```

If the `.svg` is missing, the page automatically tries `.png` instead, and if
both are missing it shows a two-letter placeholder tile.

## Using your own images

Just drop a file named after the program's slug into this folder and it will be
picked up on the next page load. For example, to replace the Blender icon:

```
images/blender.svg   (or images/blender.png)
```

The slug for each program is the `slug:` value for it in `index.html`.

A few programs currently have no distinctive logo and show a placeholder tile
until you add one:

- `proton`  → Proton (Valve)
- `dxvk`    → DXVK
- `vkd3d-proton` → VKD3D-Proton

## Re-fetching

Run `./fetch-icons.sh` to re-download the default set, which comes from
[Simple Icons](https://simpleicons.org) (crisp SVGs, released under CC0) first,
then the project's own website favicon as a fallback. Any files you have
replaced will be overwritten, so keep your own copies if you edit them.

Logos belong to their respective projects and are used here for identification.
