/*
template for a CV
still need to iron out some details
*/

// global variables
#let default_primary_color = rgb("#14A4E6")
#let default_secondary_color = rgb("#757575")
#let default_link_color = rgb("#14A4E6")
#let default_font = "Carlito"
#let default_math_font = "DejaVu Sans"
#let default_separator = text(
  fill: default_primary_color,
  // this is because in some fonts (notably computer modern), it shows the vertical line as a horizontal one
  text(font: "Carlito", " \u{007c} "),
)
// dictionary of common icons and values
#let get_default_icons(color: none) = {
  if color == none {
    color = default_primary_color
  }
  (
    "github": ("displayname": "GitHub", "logo": text(font: "FontAwesome", "\u{f09b}")),
    "linkedin": (
      "displayname": "LinkedIn",
      "logo": text(font: "FontAwesome", "\u{f08c}"),
    ),
    "personal": (
      "displayname": "Personal",
      "logo": text(font: "FontAwesome", "\u{f268}"),
    ),
    // annoyingly, Debian does not ship a version of FontAwesome which supports
    // the ORCID logo, hence here I draw my own approximation of it using Typst
    //  primitives
    "orcid": ("displayname": "ORCID", "logo": box(baseline: 0.2em, circle(
      radius: 0.5em,
      fill: color,
      inset: 0pt,
      align(center + horizon, text(size: 0.8em, fill: white, "iD")),
    ))),
  )
}

/* the main configuration */
#let conf(
  primary_color: none,
  secondary_color: none,
  link_color: none,
  font: none,
  math_font: none,
  separator: none,
  doc,
) = {
  if primary_color == none {
    primary_color = default_primary_color
  }
  if secondary_color == none {
    secondary_color = default_secondary_color
  }
  if link_color == none {
    link_color = default_link_color
  }
  if font == none {
    font = default_font
  }
  if math_font == none {
    math_font = default_math_font
  }
  if separator == none {
    separator = text(
      fill: primary_color,
      // this is because in some fonts (notably computer modern), it shows the
      // vertical line as a horizontal one
      text(font: "Carlito", " \u{007c} "),
    )
  }

  // custom show rules
  show math.equation: set text(font: math_font)
  show heading.where(level: 1): set text(fill: primary_color)
  show heading.where(level: 2): set text(size: 11pt)
  // see https://github.com/typst/typst/issues/1941
  show "C++": box

  // custom set rules
  set text(font: font, ligatures: false)
  set par(justify: true)
  set page(
    margin: (top: 0.8cm, left: 1.5cm, bottom: 1.5cm, right: 1.5cm),
    footer-descent: 0%,
    header-ascent: 0%,
  )

  // the actual content of the document
  doc
}

/* function that applies a color to a link */
#let colorlink(link_color: none, url, body) = {
  if link_color == none {
    link_color = default_link_color
  }
  text(fill: link_color, link(url)[#body <colorlink>])
}

/* function that processes links */
#let process_links(color: none, icons: none, links) = {
  if icons == none {
    icons = default_icons
  } else {
    // if the user supplies a custom dictionary, update the default one
    let old_icons = get_default_icons(color: color)
    for (key, value) in icons.pairs() {
      old_icons.insert(key, value)
    }
    icons = old_icons
  }
  links.pairs().map(
    it => text(
      fill: color,
      link(
        it.at(1),
        icons.at(it.at(0), default: (:)).at("logo", default: "") + " " + icons.at(it.at(0), default: (:)).at("displayname", default: ""),
      ),
    ),
  )
}

/* the section(s) that are colored and have a line */
#let section(color: none, title) = {
  if color == none {
    color = default_secondary_color
  }
  heading(level: 1, grid(columns: 2, gutter: 1%, [#title <section>], line(
    start: (0pt, 0.45em),
    length: 100%,
    stroke: (paint: color, thickness: 0.05em),
  )))
}

/* custom bulleted list */
#let experience_details(color: none, symbol: none, ..args) = {
  if color == none {
    color = default_primary_color
  }
  if symbol == none {
    symbol = sym.bullet
  }
  list(
    indent: 5pt,
    marker: text(fill: color, symbol),
    ..args.pos().map(it => text(size: 10pt, [#it <experience_details>])),
  )
}

/* experience that has an optional date and an optional description */
#let dated_experience(title, date: none, description: none, color: none, ..args) = {
  if color == none {
    color = default_secondary_color
  }
  [
    == #title #h(1fr) #text(fill: color, weight: "regular", size: 10pt, date) <dated_experience_header>

    #text(weight: "regular", description) <dated_experience_description>
    #experience_details(..args)

    <dated_experience>
  ]
}

/* display skills (a dictionary) */
#let show_skills(separator: none, skills) = {
  if separator == none {
    separator = default_separator
  }
  let skills_array = ()
  for (key, value) in skills.pairs() {
    skills_array.push([*#key*])
    skills_array.push(value.map(box).join(separator))
  }
  table(
    columns: 2,
    column-gutter: 2%,
    row-gutter: -0.2em,
    align: (right, left),
    stroke: none,
    ..skills_array,
  )
}

#let show_line_from_dict(dict, key) = {
  if dict.at(key, default: none) != none [#dict.at(key) \ ]
}

/* return text info about a person */
#let show_details_text(icons: none, separator: none, color: none, details) = {
  if separator == none {
    separator = default_separator
  }
  if color == none {
    color = default_link_color
  }
  if icons == none {
    icons = get_default_icons(color: color)
  }
  align(
    center + horizon,
    [
      #text(
        size: 14pt,
        [
          #details.at("prefix", default: none) #details.firstname #details.lastname
        ],
      )\
      #show_line_from_dict(details, "address")
      #show_line_from_dict(details, "phonenumber")
      #text(
        size: 13pt,
        fill: color,
        (link("mailto:" + details.email)[#raw(details.email)]),
      ) \
      #if details.at("links", default: none) != none {
        process_links(details.links, color: color, icons: icons).join(separator)
      }
    ],
  )
}

/* the main info about the person (including picture) */
#let show_details(icons: none, separator: none, color: none, details) = {
  if details.at("picture", default: "").len() > 0 {
    grid(
      columns: (1fr, 0.5fr, 2.5fr),
      align(right + horizon, image(details.picture, width: 90%)),
      h(1fr),
      show_details_text(icons: icons, separator: separator, color: color, details),
    )
  } else {
    show_details_text(icons: icons, separator: separator, color: color, details)
  }
}
