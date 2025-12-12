// Map Maker typst template

// Copyright (C) 2025 Savannah van der Kolk and contributors

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see https://www.gnu.org/licenses.

#set text(font: "Montserrat", size: 12pt)
#show heading: set text(size: 15pt, weight: "regular")
#show heading.where(level: 1): set text(weight: "bold")
#show heading.where(level: 2): set heading(bookmarked: false)

#let stop(name) = {
  (
    auto,
    0,
    align(center, circle(fill: color.rgb(0xee, 0xee, 0xee), stroke: black + 2pt, width: 15pt)),
    align(horizon, [
      = #name
    ]),
  )
}

#let destination(name) = {
  (
    auto,
    0,
    place(horizon + center, circle(fill: color.rgb(0xee, 0xee, 0xee), stroke: black + 2pt, width: 15pt, align(
      center + horizon,
      circle(fill: black, radius: 4.5pt),
    ))),
    align(horizon)[
      = #name
    ],
  )
}

#let walk_journey(time, distance, ..steps) = {
  (
    if steps.pos().len() > 0 { steps.pos().len() * .2fr + 1fr } else { 1fr },
    time,
    pad(
      align(center, line(angle: 90deg, length: 100%, stroke: (paint: blue, dash: "loosely-dashed", thickness: 4pt))),
      top: .5pt,
      bottom: .5pt,
    ),
    align(horizon, block[
      == Walk
      About #time min, #distance
      #if steps.pos().len() > 0 {
        for step in steps.pos() [
          \ #step
        ]
      }
    ]),
  )
}


#let transit_journey(transit_type, color, line_number, line_destination, time, stops) = {
  let out = ()

  assert(type(stops) == int or type(stops) == array or type(stops) == none)
  let stops_count
  if type(stops) == int {
    stops_count = stops
  } else if (type(stops) == array) {
    stops_count = stops.len()
  } else {
    stops_count = 0
  }

  let stop_places
  if type(stops) == array {
    stop_places = stops
  } else {
    stop_places = ()
  }

  out.push(
    (
      (
        .7fr,
        time,
        pad(
          align(center, line(angle: 90deg, length: 100%, stroke: (paint: color, thickness: 6pt))),
          top: .5pt,
        ),
        align(horizon, block[
          == Take #type
          #box(fill: color, outset: 2pt, radius: 1pt)[
            #set text(fill: white)
            #line_number
          ]
          #h(5pt)
          #line_destination \
          About #time min (#stops_count stop#if stops_count > 1 [s])
        ]),
      ),
    ),
  )

  if stop_places != none {
    let stop_markers = range(stop_places.len())
      .map(
        i => (
          (
            0.15fr,
            0,
            [
              #place(center, line(angle: 90deg, length: 110%, stroke: (paint: color, thickness: 6pt)), dy: -5%)
              #place(center + horizon, circle(fill: rgb(0xee, 0xee, 0xee), width: 5pt))
            ],
            align(horizon, stop_places.at(i)),
          )
        ),
      )
      .flatten()
      .chunks(4)
    for stop_item in stop_markers {
      out.push(
        stop_item,
      )
    }
  }

  return out
}

#let draw_journey(..children) = {
  grid(
    //stroke: stroke(),
    columns: (1fr, 9fr),
    rows: children.pos().flatten().chunks(4).map(a => a.at(0)),
    ..children.pos().flatten().chunks(4).map(a => ([#a.at(2)], [#a.at(3)])).flatten()
  )
  place(top + right, [
    #set text(24.5pt, fill: rgb("#595959"))
    (#children.pos().flatten().chunks(4).map(x => x.at(1)).reduce((sum, x) => sum + x) min)
  ])
}
