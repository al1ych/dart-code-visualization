# DartBoard

![logo_trans.png](logo_trans.png)

DartBoard is a cross-platform code visualization tool.
It has most of the benefits of the modern IDEs, **but**
you don't need to install it!

This is how it works:

- DartBoard takes your Dart/Flutter codebase.
- And generates a static web-site,
- That you can then just send to your supervisor doesn't
  have Dart env installed on their computer.

## Features

### High priority

- [x] Generate HTML files from source code in Dart
- [x] Highlight syntax in the generated HTML
- [x] Jump to declaration for a variable
- [x] Jump to declaration for a function
- [ ] Show documentation on cursor hover (todo: on entity usage hover) 👈🏻
- [ ] Jump to declaration for a class
- [ ] Show class specification/fields on hover
- [x] Collapse block scopes
- [x] Side-bar to switch between tabs with source files
- [x] Project tree
- [x] Upload the source files of the input project

### Medium priority

- [ ] Build archive for export
- [ ] Search by regex expression
- [ ] Upload zip project
- [ ] Upload via github repo
- [ ] Gray out vars and functions that are not used
- [ ] Gray out parts of code that are inaccessible


### Low priority

- [ ] dart run dart_code_metrics:metrics analyze lib
- [ ] Theming
- [x] Open generated HTML automatically for MacOS
- [x] Open generated HTML automatically for Windows
- [x] Open generated HTML automatically for Linux
- [ ] Add support for external plugins
- [ ] Make my own plugins
- [ ] Highlight the second parenthesis/bracket
- [ ] Scrollable minified code tab to the right of the screen (like in Sublime)
- [ ] Check code for errors
- [ ] Check linting errors
- [ ] Suggest linting fixes
- [ ] Flutter screen and widget graphical hierarchy
- [ ] Visualize dependency graph
- [ ] Visualize inheritance tree
- [ ] Pipelines.
- [ ] Rename var/function (refactor)
- [ ] Replace by regex expression (?)
  Use-case 1: automatically send the generated HTML to the code reviewer.
  Use-case 2: automatically host the result on Heroku or other hosting provider and share the link.
- [ ] Github Action. Use-case: automate generating the HTML alongside the documentation pipelines,
  linters, testers, builders, etc.
- [ ] Integration with pub.dev (make it a pub.dev package)
- [ ] Project tree as an actual tree & Project tree folder collapsing

## System requirements

- HTML should have no external dependencies.
- HTML should run on the last three major versions of Chrome, Edge, Firefox, Opera, Safari.
- HTML should run on MacOS, Windows, and Linux.
- DartBoard should have all the functionality of modern IDEs.
- DartBoard should have the look of a modern IDE design-wise.
- DartBoard should be able to deal with programs that contain a syntax error.
- DartBoard should be available as a cli tool.