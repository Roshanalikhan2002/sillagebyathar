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

## Regression investigation: October 9, 18:00–18:10 PKT

Google report `10xuadrn27` scored 73: FCP 2.6s, LCP 5.7s, Speed Index 4.2s, TBT 10ms and CLS 0.045. The low TBT does not support removing functioning scripts as the primary remedy.

Three sequential cold-cache mobile runs used the same browser, viewport, DPR and network throttle for each revision. Critical request discovery varied from approximately 0.8s to 3.8s on unchanged code. These local measurements are diagnostic, not equivalent to Google's simulated Lighthouse results.

A heading-font preload experiment (`93b1b4a`) advanced font discovery but increased hero download duration from 0.83–0.93s to 1.08–1.18s. It was reverted and pushed in `847c0eb`.

Commit `668adea` moves collection facet CSS and Quick Add modal CSS out of the shared bundle and into their rendering components. Shared product-swatch, sorting and view-details declarations stay global. No CSS declarations or animations were removed. Correction: the synced homepage renders a Quick Add dialog placeholder even though it has no Quick Add buttons. Its local modal CSS remains in the HTML; this move reduces the blocking stylesheet response, rather than removing all modal CSS bytes from the homepage.

The synced homepage's compiled CSS decreased from 184,927 to 164,730 decoded bytes. Actual encoded response bytes in the controlled runs decreased from 24,917 to 22,662 (9.1%). Its gzip estimate decreased from 29,729 to 26,677 bytes. Twelve mobile/desktop home, collection, product and search states had identical captured layout/style properties. All 126 section/block schemas still parse successfully.

After the CSS change, hero download durations were 0.83–0.87s, and LCP minus critical CSS discovery was 1.01–1.09s, versus 1.03–1.34s before the experiment. The ranges overlap; this demonstrates smaller blocking payload without establishing a 90+ Google score. A fresh Google audit of the synced revision is still required.

## Hero request competition: October 9

Google report `vbxbn4xf0a` scored 79: FCP 2.2s, LCP 4.8s, Speed Index 3.5s, TBT 60ms and CLS 0.045. These improve on report `10xuadrn27`, but the target of 90+ remains unmet.

The mobile browser trace confirms the hero is already served as WebP and has no opacity, visibility or entrance animation. Its request overlaps with seven optional module entry points whose components are absent from the homepage. The approximately three-second variation in earlier local request discovery was attributable to local DNS resolution; it must not be mistaken for theme rendering time.

Commits `027a156` and `75afe44` preserve immediate loading on other templates, in the editor, and when an optional component is in the rendered homepage content. Absent homepage feature modules are registered after the hero download, image decoding and two animation frames. Early keyboard/pointer interaction, a failed/missing hero and a five-second deadline ensure registration still happens. Header, search, cart, product-form modules and Shopify/app scripts retain their existing loaders.

Three sequential cold-cache, throttled mobile runs of `75afe44` confirmed all seven optional requests start after both the hero download and recorded LCP, all seven custom elements register, and no page JavaScript errors occur. These entry points total 4,797 encoded bytes; they are rescheduled, not removed. Hero downloads took 0.83–0.89s. LCP after the document response started ranged from 1.03–1.20s, with a median of 1.13s. These local measurements do not establish a Google score improvement and should be followed by a fresh audit of the synced revision.

The controlled early-interaction check held the hero response and verified all seven custom elements could register before the image was released. Product and collection pages retained all seven normal module script tags without the deferred loader. Search results, clear and Escape-close passed, with no JavaScript errors; twelve captured home/collection/product mobile and desktop layout/search states remained identical.
