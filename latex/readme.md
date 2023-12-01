# Custom LaTeX documentclass

**Requires LuaLaTeX compiler**

This is a document class file that based on article.cls that polishes and standardizes sizes and skips
between text, equations, floats, etc.
It is optimzied for writing short to medium length reports comprised of prose with figures, tables, and/or equations.  

It includes a numerous useful packages, patches certain default/package-provided features for consistency,
and defines a few quality-of-life macros.

Includes out-sourced code.
Their sources are provided in comments in the file.


## Stylistic Features

11pt, A4 paper size, 5.2" x 8.6" text area.

Use of `microtype` and unicode support with LuaLaTeX `fontspec`.

Custom title page with two fields added to the article class default:
`\subtitle` is a centered text placed under the title, author, and date; 
`titlenotes` is a chunk of text placed flush to the bottom of the title page.  
Each of the four fields can be selectively disabled.
(By not setting any value to `subtitle` or `titlenotes` or by setting `author=false` or `date=false` in the class options.)

Redefined `\paragraph` to act like a lower-level unnumbered header.

Does not highlight hyperlinks in a different color.

Uses paragraph indentation AND inter-paragraph spacing.
**The paragraph spacing (and all other skips) scale in proportion with the line spacing.**
This is the biggest feature; all sizes are carefully related to each other such that changing linespacing will nicely adjust everything else.

Uses a fancy ordinal date format like "Sunday 1st of January, 2024" (the ordinal is superscripted).

Uses unicode math font, and sets an emoji font (Google's NotoEmoji) to directly support unicode emoji characters in your `.tex` file.


## Options

| option           | default value | description                                   
|------------------|---------------|-------------------------------------------
| linespacing      | single        | string (single, onehalf, double): the document's line spacing
| author           | true          | bool: whether author should be shown on titlepage
| date             | true          | bool: whether date should be shown on titlepage
| contents         | true          | bool: whether a table of contents should be generated
| separatetoc      | true          | bool: place ToC after titlepage or on same page?
| bib              | true          | bool: whether to support a bibliography (uses biblatex with biber)
| debug            | false         | bool: shows construction visualization using `lua-visual-debug`
| compacteqs       | false         | bool: whether to use reduced spacing between equations and text
| timestamp        | false         | bool: whether to include a time of compilation in footer of title page
| plotting         | false         | bool: whether to load `pgfplots` and `tikz`
| compacttoc       | false         | bool: structures ToC in two columns to take up less vertical space
| compacttitle     | false         | bool: various changes to make the title stuff take less space. If this is on titlenotes are not allowed. This is best used alongside compacttoc. Try it and see

Because `titlenotes` are placed at the bottom of the title page (and hence fills the entire title page), 
when it is specified and shown, `separatecontents` will have no apparent effect.


## Patches

Patches `amsmath` display math environments to automatically use `\abovedisplayshortskip`
just like the vanilla `equation` environment.

Patches biblatex to be able to specify and show the main website title for `@online` entires.
The key `maintitle` is used for this.


## Custom Macros

`\lb`: inserts empty line

`\pskip`: inserts paragraph space

`\d{<var>}`: properly typesets a differential operation. 
`\d{x}` renders dx but beautifully and consistently. (Actually, just use `physics`'s `\dd`.)

`\vbreak`: use after (or maybe? before) a wrapped figure (`wrapfig2` package) if it manages to break everything after.
(Happens when you placed it next to a list or section header.)

`\makebibliography`: like \maketitle, but, well... makes the bibliography (with a nice section header).

`\lengthinfo`: prints the values of all kinds of sizes and skips

`\ShortSkip`: use at the end of a paragraph before an equation environment to force a negative height adjustment
to imitate a \abovedisplayshortskip even when it isn't automatically used.
This seems to only rarely be necessary with edge-case spacing around `equation` environments; the ams patches seem to function even better
than the vanilla feature.

`\shortenfences{<ldelim>}{<math>}{<rdelim>}`: like `$\left<ldelim> <math> \right<rdelim>$` but adjusts the heights of
the large brackets to better fit lopsided fractions in \<math>.

`\pl`: prints a length but in "bip points" (PostScript/international points) or 1/72ths of an inch (LaTeX "points" are retarded and are 1/72.27)

`\halfwidth`: a length that is `0.5\textwidth - 0.5\columnsep` - useful to set the widths of side-by-side figures/minipages so they have a full columnsep between them (use `\hspace{\columnsep}` or other alignment techniques in between)

`\mathfracstrut`: like `\mathstrut` but is the height of a full fraction with `\mathstrut` in both the nu- and denu-merators

`\invisibox`: places invisible space-occupying box of specified width and height

`\hollowbox`: same as `\invisibox` but draws a visible outline

`\frametext` puts text into a structure like `\hollowbox`, but with nice spacing around all the rules

`\fdom` and `\fim`: typesets the letters "dom" and "im" in mathrm; theyre used to denote "domain" and "image" of a function


## Custom Environments

`bottompar`: places its contents at the bottom of the page.
Everything ater continutes on the next page. Used for `titlenotes`

`itemizenospace`: a modified list environment with normal line spacing and no indentation.

`enumeratenospace`: a modified enumerate environment with normal line spacing and no indentation.

`enumns`: a better version of `enumeratenospace` defined using the `enumitem` package

`ruled`: puts hrules above and below a section of text, but with good spacing. Accepts optional parameter as the "header"

`wrappage`: some wrapfigure on steroid found on stack exchange... 

In addition, there are three new custom table column types: `L`, `C`, and `R`.
They are the same as their built-in lowercase variants but has the entire column in math mode.


## Your Job

To produce a consistent document, you need to adhere to certain practices.
I cba to list them all now, but:
- don't ever change the font size or style in the main body
- don't ever use spacing commands like `\vspace` in text. They may only rarely be necessary to adjust `wrapfigure`s.
- render figures and graphs consistent in style before including them, or just use tikz/pgfplots
- either insert figures as full-width, or `wrapfigure` them or use `minipage`s to place multiple stacked horizontally. Same applies for tables; don't have small floats leaving horizontal space.
- use `siunitx` commands for typesetting numbers or quantities with units
- use tabularx `tabular` tables
- caption everything, with the caption on top of tables but underneath figures
- use `\autoref` whenever possible while referencing labels
- use the provided environments, especially the lists and `ruled`
- use the provided macros, especially `\makebibliography`, `frametext`...
