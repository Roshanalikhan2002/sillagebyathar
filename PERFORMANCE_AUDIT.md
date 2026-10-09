# Mobile performance audit

The audit scanned theme assets, Liquid files, templates, settings and translations, and parsed all 126 section/block schemas without errors. Network measurements use the connected Shopify draft preview with `?pb=0`.

The last Google report before this change scored 77 (FCP 3.1s, LCP 4.5s, Speed Index 4.0s, TBT 0ms). A smaller CSS bundle alone has not established a score improvement.

## Largest network costs

An isolated local Lighthouse capture recorded approximately 529KiB of scripts, 374KiB of images, 178KiB of fonts and 73KiB for the main HTML response. These measurements are a local snapshot, not the Google report's transfer totals.

- Shopify web pixels, WhatsApp chat and Judge.me account for significant script transfer. Their functions are retained.
- Newsreader 200 and 700 alone contain 145,532 bytes. Latin subsets of the exact original files contain 114,380 bytes: 31,152 bytes (21.4%) less.
- Large product and discovery images remain lazy-loaded. Their dimensions and original automatic card sizing are retained; their requests now have low priority so critical content can load first.
- Body fonts retain their original files and preload. A body-font subset experiment produced duplicate requests and was removed.

## Font safeguards

The original font faces remain available for characters outside the Latin/symbol subset. Only the exact Shopify font revisions used to build these assets match the subset rules. Font settings and other revisions retain normal Shopify behavior.

Subsets preserve glyph outlines, hinting, layout features and variation axes. Browser canvas comparisons of headings, product titles, currency, ligatures and accented text found identical widths and pixels. The original Newsreader OFL license accompanies the derived assets in `assets/newsreader-OFL.txt`.

After pushing, verify actual font requests, extended-language fallback, mobile/desktop layouts, browser errors and performance on the synced preview. A 90+ Google mobile score has not yet been verified.
