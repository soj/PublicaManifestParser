# PublicaManifestParser

A lightweight Swift example app for parsing HLS manifests and detecting server-inserted ad breaks.

## Why this exists

Sometimes you need to insert ads on the server side. Users might grumble, but from a business standpoint it’s a must. You have two options:

- **SDK-based**: e.g. Google IMA Dynamic Ad Insertion – comes with service + SDK.  
- **No-SDK**: simpler, zero third-party code, but you lose built-in analytics.

With HLS, the traditional no-SDK approach is to embed `#EXT-X-CUE-OUT / IN` or `#EXT-X-DISCONTINUITY` tags in your playlist. Under the hood, `AVPlayer` just switches sources silently—it won’t tell you who actually saw the ads. Analytics are always priority #1, so you have to roll your own:

1. **Fetch** the manifest as text.
2. **Parse** the tags yourself to count breaks, start times, durations.
3. **Emit** analytics events based on what you parsed.

That’s exactly what this parser does—no fuzz, no bloat.

## Features

- Detects `#EXT-X-DISCONTINUITY` segments
- Reports break count, start timestamps, durations
- Zero dependencies beyond Foundation

## Usage 

```swift
let content = try await manifestProvider.getManifestContent()
try parser.parse(manifestContent: content)
adBreaks = parser.getAdBreaks()
```

## Example

Take a look at the included `manifest.txt`. It contains a few `#EXT-X-DISCONTINUITY` tags. Run the parser against it to see how it picks up each ad break.
