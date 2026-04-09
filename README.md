# spreadsheets-in-tex

TeX ports of the spreadsheets I already had on my hard drive.
Now that I've created these, I consider them "canonical": I'll be just updating these from now on.

## Why?

One day, I opened Numbers (Apple's answer to Excel) and it told me that the version I'd been using for some time wasn't going to be updated anymore.
It then prompted me to open the App Store for a new version, with the old one being renamed to "Numbers 14.5".
After looking further, I noticed that it looked a lot like Apple was trying to somehow merge their answers to Adobe Creative Cloud and to Office, and to have a monthly subscription model for both.
Ew.
This gave me the motivation to do this, which has the added benefit of being easier to publish.

## What *are* the spreadsheets, anyway?

Before the incident discussed in the "Why?" section, I had four spreadsheets on my hard drive:

- A table of the various tables that the _Puyo Puyo Tetris_ games use to convert quantities of garbage lines (in Tetris) to garbage Puyos (in Puyo Puyo) and vice versa. This became `puyotet.lua`; there's nothing to typeset, so I didn't create a TeX file for it.
- A table of the required-score tables in [Steamodded](https://github.com/Steamodded/smods), for the first eight difficulty modifiers (White, Green, Purple, and five more) and up to where it normally overflows to infinity (at 2^1024). Also a glorified database with no reason to spend effort formatting it; I was just more curious about a few things for myself.
- A log of the parameters for [PEGG](https://googology.miraheze.org/wiki/Psi%27s_Ever-Growing_Googolism). Someone else did the work for E through Q, but then just gave up with "we've reached the end" once it would have transitioned to R (as R doesn't have a formal definition, though it had an intended "scale" and a definition for whole-number parameters). This became `pegg/`.
- A chart of which choreographies (of 19, 20, and 21 difficulty) I've successfully completed in _Pump It Up_. These get [pretty intense](https://youtu.be/xJ6bSoo4URg), and you need about twenty 19's to unlock the "Intermediate Lv. 10" title and twenty 20's to unlock "Advanced Lv. 1". This became `pump/`.

While I do play a lot of modded _Celeste_, it's probably too late for me to really create a sheet for that; so much of the data I'd like to include is just lost to time.
