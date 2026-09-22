# Effective Dart: Documentation

> Vendored from [dart.dev/effective-dart/documentation](https://dart.dev/effective-dart/documentation)
> ([source](https://github.com/dart-lang/site-www/blob/main/src/content/effective-dart/documentation.md),
> CC BY 4.0) so it is available offline to contributors and coding agents. The canonical version on
> dart.dev wins where the two differ. Where [`STYLE_GUIDE.md`](STYLE_GUIDE.md) contradicts this
> document, the style guide wins.

It's easy to think your code is obvious today without realizing how much you
rely on context already in your head. People new to your code, and
even your forgetful future self won't have that context. A concise, accurate
comment only takes a few seconds to write but can save one of those people
hours of time.

We all know code should be self-documenting and not all comments are helpful.
But the reality is that most of us don't write as many comments as we should.
It's like exercise: you technically *can* do too much, but it's a lot more
likely that you're doing too little. Try to step it up.

## Comments

The following tips apply to comments that you don't want included in the
generated documentation.

### DO format comments like sentences

**Good:**

```dart
// Not if anything comes before it.
if (_chunks.isNotEmpty) return false;
```

Capitalize the first word unless it's a case-sensitive identifier. End it with a
period (or "!" or "?", I suppose). This is true for all comments: doc comments,
inline stuff, even TODOs. Even if it's a sentence fragment.

### DON'T use block comments for documentation

**Good:**

```dart
void greet(String name) {
  // Assume we have a valid name.
  print('Hi, $name!');
}
```

**Bad:**

```dart
void greet(String name) {
  /* Assume we have a valid name. */
  print('Hi, $name!');
}
```

You can use a block comment (`/* ... */`) to temporarily comment out a section
of code, but all other comments should use `//`.

## Doc comments

Doc comments are especially handy because [`dart doc`][] parses them 
and generates [beautiful doc pages][docs] from them. 
A doc comment is any comment that appears before a declaration 
and uses the special `///` syntax that `dart doc` looks for.

[`dart doc`]: /tools/dart-doc
[docs]: https://api.dart.dev

### DO use `///` doc comments to document members and types


Using a doc comment instead of a regular comment enables 
[`dart doc`][] to find it
and generate documentation for it.

**Good:**

```dart
/// The number of characters in this chunk when unsplit.
int get length => ...
```

**Bad:**

```dart
// The number of characters in this chunk when unsplit.
int get length => ...
```

For historical reasons, `dart doc` supports two syntaxes of doc comments: `///`
("C# style") and `/** ... */` ("JavaDoc style"). We prefer `///` because it's
more compact. `/**` and `*/` add two content-free lines to a multiline doc
comment. The `///` syntax is also easier to read in some situations, such as
when a doc comment contains a bulleted list that uses `*` to mark list items.

If you stumble onto code that still uses the JavaDoc style, consider cleaning it
up.

### PREFER writing doc comments for public APIs


You don't have to document every single library, top-level variable, type, and
member, but you should document most of them.

### CONSIDER writing a library-level doc comment

Unlike languages like Java where the class is the only unit of program
organization, in Dart, a library is itself an entity that users work with
directly, import, and think about. That makes the `library` directive a great
place for documentation that introduces the reader to the main concepts and
functionality provided within. Consider including:

* A single-sentence summary of what the library is for.
* Explanations of terminology used throughout the library.
* A couple of complete code samples that walk through using the API.
* Links to the most important or most commonly used classes and functions.
* Links to external references on the domain the library is concerned with.

To document a library, place a doc comment before
the `library` directive and any annotations that might be attached
at the start of the file.

**Good:**

```dart
/// A really great test library.
@TestOn('browser')
library;
```

### CONSIDER writing doc comments for private APIs

Doc comments aren't just for external consumers of your library's public API.
They can also be helpful for understanding private members that are called from
other parts of the library.

### DO start doc comments with a single-sentence summary

Start your doc comment with a brief, user-centric description ending with a
period. A sentence fragment is often sufficient. Provide just enough context for
the reader to orient themselves and decide if they should keep reading or look
elsewhere for the solution to their problem.

**Good:**

```dart
/// Deletes the file at [path] from the file system.
void delete(String path) {
  ...
}
```

**Bad:**

```dart
/// Depending on the state of the file system and the user's permissions,
/// certain operations may or may not be possible. If there is no file at
/// [path] or it can't be accessed, this function throws either [IOError]
/// or [PermissionError], respectively. Otherwise, this deletes the file.
void delete(String path) {
  ...
}
```

### DO separate the first sentence of a doc comment into its own paragraph

Add a blank line after the first sentence to split it out into its own
paragraph. If more than a single sentence of explanation is useful, put the
rest in later paragraphs.

This helps you write a tight first sentence that summarizes the documentation.
Also, tools like `dart doc` use the first paragraph as a short summary in places
like lists of classes and members.

**Good:**

```dart
/// Deletes the file at [path].
///
/// Throws an [IOError] if the file could not be found. Throws a
/// [PermissionError] if the file is present but could not be deleted.
void delete(String path) {
  ...
}
```

**Bad:**

```dart
/// Deletes the file at [path]. Throws an [IOError] if the file could not
/// be found. Throws a [PermissionError] if the file is present but could
/// not be deleted.
void delete(String path) {
  ...
}
```

### AVOID redundancy with the surrounding context

The reader of a class's doc comment can clearly see the name of the class, what
interfaces it implements, etc. When reading docs for a member, the signature is
right there, and the enclosing class is obvious. None of that needs to be
spelled out in the doc comment. Instead, focus on explaining what the reader
*doesn't* already know.

**Good:**

```dart
class RadioButtonWidget extends Widget {
  /// Sets the tooltip to [lines].
  ///
  /// The lines should be word wrapped using the current font.
  void tooltip(List<String> lines) {
    ...
  }
}
```

**Bad:**

```dart
class RadioButtonWidget extends Widget {
  /// Sets the tooltip for this radio button widget to the list of strings in
  /// [lines].
  void tooltip(List<String> lines) {
    ...
  }
}
```

Only add doc comments when providing context, caveats, or usage details
not immediately obvious from the surrounding context.


### PREFER starting comments of a function or method with third-person verbs if its main purpose is a side effect

The doc comment should focus on what the code *does*.

**Good:**

```dart
/// Connects to the server and fetches the query results.
Stream<QueryResult> fetchResults(Query query) => ...

/// Starts the stopwatch if not already running.
void start() => ...
```

### PREFER starting a non-boolean variable or property comment with a noun phrase

The doc comment should stress what the property *is*. This is true even for
getters which may do calculation or other work. What the caller cares about is
the *result* of that work, not the work itself.

**Good:**

```dart
/// The current day of the week, where `0` is Sunday.
int weekday;

/// The number of checked buttons on the page.
int get checkedCount => ...
```

### PREFER starting a boolean variable or property comment with "Whether" followed by a noun or gerund phrase

The doc comment should clarify the states this variable represents.
This is true even for getters which may do calculation or other work.
What the caller cares about is the *result* of that work, not the work itself.

**Good:**

```dart
/// Whether the modal is currently displayed to the user.
bool isVisible;

/// Whether the modal should confirm the user's intent on navigation.
bool get shouldConfirm => ...

/// Whether resizing the current browser window will also resize the modal.
bool get canResize => ...
```

> This guideline intentionally doesn't include using "Whether or not". In many
> cases, usage of "or not" with "whether" is superfluous and can be omitted,
> especially when used in this context.

### PREFER a noun phrase or non-imperative verb phrase for a function or method if returning a value is its primary purpose

If a method is *syntactically* a method, but *conceptually* it is a property,
and is therefore [named with a noun phrase or non-imperative verb phrase][parameterized_property_name],
it should also be documented as such.
Use a noun-phrase for such non-boolean functions, and
a phrase starting with "Whether" for such boolean functions,
just as for a syntactic property or variable.

**Good:**

```dart
/// The [index]th element of this iterable in iteration order.
E elementAt(int index);

/// Whether this iterable contains an element equal to [element].
bool contains(Object? element);
```

> This guideline should be applied based on whether the declaration is
> conceptually seen as a property.
>
> Sometimes a method has no side effects, and might
> conceptually be seen as a property, but is still
> simpler to name with a verb phrase like `list.take()`.
> Then a noun phrase should still be used to document it.
> _For example `Iterable.take` can be described as
> "The first \[count\] elements of ..."._

[parameterized_property_name]: design#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose

### DON'T write documentation for both the getter and setter of a property

If a property has both a getter and a setter, then create a doc comment for
only one of them. `dart doc` treats the getter and setter like a single field,
and if both the getter and the setter have doc comments, then
`dart doc` discards the setter's doc comment.

**Good:**

```dart
/// The pH level of the water in the pool.
///
/// Ranges from 0-14, representing acidic to basic, with 7 being neutral.
int get phLevel => ...
set phLevel(int level) => ...
```

**Bad:**

```dart
/// The depth of the water in the pool, in meters.
int get waterDepth => ...

/// Updates the water depth to a total of [meters] in height.
set waterDepth(int meters) => ...
```

### PREFER starting library or type comments with noun phrases

Doc comments for classes are often the most important documentation in your
program. They describe the type's invariants, establish the terminology it uses,
and provide context to the other doc comments for the class's members. A little
extra effort here can make all of the other members simpler to document.

The documentation should describe an *instance* of the type.

**Good:**

```dart
/// A chunk of non-breaking output text terminated by a hard or soft newline.
///
/// ...
class Chunk {
   ...
}
```

### CONSIDER including code samples in doc comments

**Good:**

````dart
/// The lesser of two numbers.
///
/// ```dart
/// min(5, 3) == 3
/// ```
num min(num a, num b) => ...
````

Humans are great at generalizing from examples, so even a single code sample
makes an API easier to learn.

### DO use square brackets in doc comments to refer to in-scope identifiers


If you surround things like variable, method, or type names in square brackets,
then `dart doc` looks up the name and links to the relevant API docs.
Parentheses are optional but can
clarify you're referring to a function or constructor.
The following partial doc comments illustrate a few cases
where these comment references can be helpful:

**Good:**

```dart
/// Throws a [StateError] if ...
///
/// Similar to [anotherMethod()], but ...
```

To link to a member of a specific class, use the class name and member name,
separated by a dot:

**Good:**

```dart
/// Similar to [Duration.inDays], but handles fractional days.
```

The dot syntax can also be used to refer to named constructors. For the unnamed
constructor, use `.new` after the class name:

**Good:**

```dart
/// To create a point, call [Point.new] or use [Point.polar] to ...
```

To learn more about the references that
the analyzer and `dart doc` support in doc comments,
check out [Documentation comment references][].

[Documentation comment references]: /tools/doc-comments/references

### DO use prose to explain parameters, return values, and exceptions

Other languages use verbose tags and sections to describe what the parameters
and returns of a method are.

**Bad:**

```dart
/// Defines a flag with the given name and abbreviation.
///
/// @param name The name of the flag.
/// @param abbr The abbreviation for the flag.
/// @returns The new flag.
/// @throws ArgumentError If there is already an option with
///     the given name or abbreviation.
Flag addFlag(String name, String abbreviation) => ...
```

The convention in Dart is to integrate that into the description of the method
and highlight parameters using square brackets.

Consider having sections starting with "The \[parameter\]" to describe
parameters, with "Returns" for the returned value and "Throws" for exceptions.
Errors can be documented the same way as exceptions,
or just as requirements that must be satisfied, without documenting the
precise error which will be thrown.

**Good:**

```dart
/// Defines a flag with the given [name] and [abbreviation].
///
/// The [name] and [abbreviation] strings must not be empty.
///
/// Returns a new flag.
///
/// Throws a [DuplicateFlagException] if there is already an option named
/// [name] or there is already an option using the [abbreviation].
Flag addFlag(String name, String abbreviation) => ...
```

### DO put doc comments before metadata annotations

**Good:**

```dart
/// A button that can be flipped on and off.
@Component(selector: 'toggle')
class ToggleComponent {}
```

**Bad:**

```dart
@Component(selector: 'toggle')
/// A button that can be flipped on and off.
class ToggleComponent {}
```

## Markdown

You are allowed to use most [markdown][] formatting in your doc comments and
`dart doc` will process it accordingly using the [markdown package.][]

[markdown]: https://daringfireball.net/projects/markdown/
[markdown package.]: https://pub.dev/packages/markdown

There are tons of guides out there already to introduce you to Markdown. Its
universal popularity is why we chose it. Here's just a quick example to give you
a flavor of what's supported:

````dart
/// This is a paragraph of regular text.
///
/// This sentence has *two* _emphasized_ words (italics) and **two**
/// __strong__ ones (bold).
///
/// A blank line creates a separate paragraph. It has some `inline code`
/// delimited using backticks.
///
/// * Unordered lists.
/// * Look like ASCII bullet lists.
/// * You can also use `-` or `+`.
///
/// 1. Numbered lists.
/// 2. Are, well, numbered.
/// 1. But the values don't matter.
///
///     * You can nest lists too.
///     * They must be indented at least 4 spaces.
///     * (Well, 5 including the space after `///`.)
///
/// Code blocks are fenced in triple backticks:
///
/// ```dart
/// this.code
///     .will
///     .retain(its, formatting);
/// ```
///
/// The code language (for syntax highlighting) defaults to Dart. You can
/// specify it by putting the name of the language after the opening backticks:
///
/// ```html
/// <h1>HTML is magical!</h1>
/// ```
///
/// Links can be:
///
/// * https://www.just-a-bare-url.com
/// * [with the URL inline](https://google.com)
/// * [or separated out][ref link]
///
/// [ref link]: https://google.com
///
/// # A Header
///
/// ## A subheader
///
/// ### A subsubheader
///
/// #### If you need this many levels of headers, you're doing it wrong
````

### AVOID using markdown excessively

When in doubt, format less. Formatting exists to illuminate your content, not
replace it. Words are what matter.

### AVOID using HTML for formatting

It *may* be useful to use it in rare cases for things like tables, but in almost
all cases, if it's too complex to express in Markdown, you're better off not
expressing it.

### PREFER backtick fences for code blocks

Markdown has two ways to indicate a block of code: indenting the code four
spaces on each line, or surrounding it in a pair of triple-backtick "fence"
lines. The former syntax is brittle when used inside things like Markdown lists
where indentation is already meaningful or when the code block itself contains
indented code.

The backtick syntax avoids those indentation woes, lets you indicate the code's
language, and is consistent with using backticks for inline code.

**Good:**

```dart
/// You can use [CodeBlockExample] like this:
///
/// ```dart
/// var example = CodeBlockExample();
/// print(example.isItGreat); // "Yes."
/// ```
```

**Bad:**

```dart
/// You can use [CodeBlockExample] like this:
///
///     var example = CodeBlockExample();
///     print(example.isItGreat); // "Yes."
```

## Writing

We think of ourselves as programmers, but most of the characters in a source
file are intended primarily for humans to read. English is the language we code
in to modify the brains of our coworkers. As for any programming language, it's
worth putting effort into improving your proficiency.

This section lists a few guidelines for our docs. You can learn more about
best practices for technical writing, in general, from articles such as
[Technical writing style](https://en.wikiversity.org/wiki/Technical_writing_style).

### PREFER brevity

Be clear and precise, but also terse.

### AVOID abbreviations and acronyms unless they are obvious

Many people don't know what "i.e.", "e.g." and "et al." mean. That acronym
that you're sure everyone in your field knows may not be as widely known as you
think.

### PREFER using "this" instead of "the" to refer to a member's instance

When documenting a member for a class, you often need to refer back to the
object the member is being called on. Using "the" can be ambiguous.
Prefer having some qualifier after "this", a sole "this" can be ambiguous too.

```dart
class Box {
  /// The value this box wraps.
  Object? _value;

  /// Whether this box contains a value.
  bool get hasValue => _value != null;
}
```
