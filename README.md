# DartBoard

![img_2.png](logo.png)

DartBoard is a cross-platform code visualization tool.
It has most of the benefits of the modern IDEs, **but**
you don't need to install it!

This is how it works:

- DartBoard takes your Dart/Flutter codebase.
- It then processes it into a static web-site,
- That you can then just send to your supervisor who doesn't
  even need to have Dart env installed on their computer.

## Features

### High priority

- [ ] Generate HTML files from source code in Dart
- [x] Highlight syntax in the generated HTML
- [ ] Jump to declaration for a variable
- [ ] Jump to declaration for a function
- [ ] Show documentation on cursor hover
- [ ] 👉🏻 Collapse block scopes
- [ ] Upper tab bar to switch between tabs with source files
- [ ] Project tree

### Medium priority

- [ ] Theming
- [ ] Search by regex expression
- [ ] Replace by regex expression
- [ ] Rename var/function (refactor)
- [ ] Upload zip project
- [ ] Upload via github repo
- [ ] Project tree folder collapsing

### Low priority

- [x] Open generated HTML automatically for MacOS
- [ ] Open generated HTML automatically for Windows
- [ ] Open generated HTML automatically for Linux
- [ ] Gray out vars and functions that are not used
- [ ] Gray out parts of code that are inaccessible
- [ ] Add support for external plugins
- [ ] Make my own plugins
- [ ] Highlight the second parenthesis/bracket
- [ ] Scrollable minified code copy tab to the right of the screen (like in Sublime)
- [ ] Check code for errors
- [ ] Check linting errors
- [ ] Suggest linting fixes
- [ ] Flutter screen and widget graphical hierarchy
- [ ] Visualize dependency graph
- [ ] Visualize inheritance tree
- [ ] Pipelines.
  Use-case 1: automatically send the generated HTML to the code reviewer.
  Use-case 2: automatically host the result on Heroku or other hosting provider and share the link.
- [ ] Github Action. Use-case: automate generating the HTML alongside the documentation pipelines,
  linters, testers, builders, etc.
- [ ] Integration with pub.dev (make it a pub.dev package)

## System requirements

- HTML should have no external dependencies.
- HTML should run on the last three major versions of Chrome, Edge, Firefox, Opera, Safari.
- HTML should run on MacOS, Windows, and Linux.
- DartBoard should have all the functionality of modern IDEs.
- DartBoard should have the look of a modern IDE design-wise.
- DartBoard should be able to deal with programs that contain a syntax error.
- DartBoard should be available as a cli tool.