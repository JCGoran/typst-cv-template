#import "template.typ": conf, date, show_skills

// import details about a person as a typst dictionary
// you can also define it here, I just find it easier to keep this constant,
// and change the content if needed
#let details = toml("cv_params.toml")

// don't forget this
#show: doc => conf(details, doc)

= Work Experience

== Software Engineer #date([Jan 2023 -- present])
=== Company Foo

- #lorem(100)

== Junior Software Engineer// no date here
=== Company Bar

- #lorem(30)
- #lorem(10)
- #lorem(50)

= Education

== Master in Philosophy #date([2015 -- 2017])

#lorem(40)

= Skills

#show_skills(
  (
    "Programming Languages": ("Python", "C++", "Rust", "Typst (does that count?)"),
    "Technologies": ("GitHub Actions", "GitLab CI", "Others"),
    "Lipsum": lorem(12).split(),
  ),
)

= Other

- #lorem(50)
- #lorem(100)
- #lorem(35)
