Welcome to Stream’s Flutter repository! Thank you for taking the time to contribute to our codebase. 🎉.

This document outlines a set of guidelines for contributing to Stream and our packages. These are mostly guidelines, not necessarily a fixed set of rules. Please use your best judgment and feel free to propose changes to this document in a pull request.

---

# If I have a question, do I need to read this guide? 💬

Probably not. Most questions can be answered by looking at our Frequently Asked Questions (FAQ) or Flutter Cookbook. 

If you are still having doubts around a specific API, please create an issue on your repository with the label "Question". Community members or team members would be happy to assist. 

In cases where developers suspect the issue may be a defect or bug, please use one of our pre-made templates to file an issue. Be sure to include as many details as possible to help our team reproduce the error. A good bug report should have clear and consistent instructions for reproducing, screenshots or videos of the bug if applicable, and information on your environment setup and Flutter version.

You can include the output of `flutter doctor --verbose` when filing an issue.

🔗: [https://github.com/GetStream/stream-chat-flutter/issue](https://github.com/GetStream/stream-chat-flutter/issues)

---

# What should I know before diving into code? 🤔

Stream's Flutter code is kept in a single mono-repository consisting of multiple packages. Source code for each package can be found under the top-level  `/packages` directory. 

<img width="1436" alt="Screen_Shot_2021-03-31_at_4 13 52_PM" src="https://user-images.githubusercontent.com/20601437/124240912-8791a080-db1b-11eb-9467-b00e9d14b1ca.png">

### Project Structure 🧱

`.github` - GitHub files including issue templates, pull request templates, and Github Action scripts.

`images` - Static images used in our README and elsewhere. 

`package` - Directory containing Stream's Flutter source code. Each sub-directory represents a Flutter (or Dart) project. 

`.gitignore` - Listing of files and file extensions ignored for this project.

`CODE_OF_CONDUCT` - Our values, approach to writing code, and expectations for Stream developers and contributors. 

`LICENSE` - Legal. Feast your eyes on the fine print.

`README` - Project overview.

`melos.yaml` - Configuration file used to control [Melos](https://pub.dev/packages/melos), our mono-repo management tool of choice. 

### Current Stream Packages

`stream_chat` - Stream Chat is a low-level wrapper around Stream's REST API and web sockets. It contains minimal external dependencies and does not rely on Flutter. It is possible to use this package on most platforms supported by Dart. 

`stream_chat_flutter_core` - This package provides business logic to fetch common things required to integrate Stream Chat into your application. The core package allows more customization, providing business logic but no UI components.

`stream_chat_flutter` - This library includes both a low-level chat SDK and a set of reusable and customizable UI components.

`stream_chat_persistence` - This package provides a persistence client for fetching and saving chat data locally. Stream Chat Persistence uses Moor as a disk cache.

`stream_chat_localizations` - This package provides a set of localizations for the SDK.

### Local Setup

Congratulations! 🎉.  You've successfully cloned our repo, and you are ready to make your first contribution. Before you can start making code changes, there are a few things to configure. 

**Melos Setup**

Stream uses `melos` to manage our mono-repository. For those unfamiliar, Melos is used to  split up large code bases into separate independently versioned packages. To install melos, developers can run the following command:

```bash
pub global activate melos 
```

Once activated, users can now "bootstrap" their local clone by running the following:

```bash
melos bootstrap
```

Bootstrap will automatically fetch and link dependencies for all packages in the repo. It is the melos equivalent of running `flutter pub get`.

Bonus Tip: Did you know it is possible to define and run custom scripts using Melos? Our team uses custom scripts for all sorts of actions like testing, lints, and more. 

To run a script, use `melos run <script name>`.

---

# How can I contribute?

Are you ready to dive into code? It's pretty easy to get up and running with your first Stream contribution. If this is your first time sending a PR to Stream, please read the above section on [local setup](https://github.com/GetStream/stream-chat-flutter/blob/develop/CONTRIBUTING.md#local-setup) before continuing. 

## Filing bugs 🐛

Before filing bugs, take a look at our existing backlog. For common bugs, there might be an existing ticket on GitHub. 

To quickly narrow down the amount of tickets on Github, try filtering based on the label that best suites the bug.

![image](https://user-images.githubusercontent.com/20601437/124240983-9d9f6100-db1b-11eb-952f-3c0cc60a910e.png)

Didn't find an existing issue? Go ahead and file a new bug using one of our pre-made issue templates. 

![image](https://user-images.githubusercontent.com/20601437/124241045-aee86d80-db1b-11eb-89eb-f4189019ac3e.png)

Be sure to provide as much information as possible when filing bug reports. A good issue should have steps to reproduce and information on your development environment and expected behavior. 

Screenshots and gifs are always welcomed :)

## Feature Request 💡

Have an idea for a new feature? We would love to hear about it! 

Our team uses GitHub discussions to triage and discuss feature requests. Before opening a new topic, please check our existing issues and pull requests to ensure the feature you are suggesting is not already in progress. 

To file a feature request, select the "Discussions" tab on our GitHub repo or [visit this link](https://github.com/GetStream/stream-chat-flutter/discussions/new). Once there, change the default category to "**💡 Ideas**", then write a brief description of your feature/change.

Screenshots, sketches, and sample code are all welcomed!

![image](https://user-images.githubusercontent.com/20601437/124241092-bc055c80-db1b-11eb-9205-7e3d7c157af1.png)

Here are some common questions to answer when filing a feature request:

**Is your feature request related to a problem? Please describe.**

A clear and concise description of what the problem is. Ex. I'm always frustrated when [...]

**Describe the solution you'd like.**

A clear and concise description of what you want to happen.

**Describe alternatives you've considered.**

A clear and concise description of any alternative solutions or features you've considered.

**Additional context.**

Add any other context or screenshots about the feature request here.

## Pull Request 🎉

![image](https://user-images.githubusercontent.com/20601437/124241146-c7f11e80-db1b-11eb-9588-d9f578ec004a.png)

Thank you for taking the time to submit a patch and contribute to our codebase. You rock!  

Before we can land your pull request, please don't forget to [sign Stream's CLA (Contributor License Agreement](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform). 📝

### PR Semantics 🦄

Our team uses [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) when coding and creating PRs. This standard makes it easy for our team to review and identify commits in our repo quickly. 

While we don't expect developers to follow the specification down to every commit message, we enforce semantics on PR titles. 

PR titles should follow the format below:

```jsx
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

1. **fix:** a commit of the *type* `fix` patches a bug in your codebase (this correlates with **`[PATCH](http://semver.org/#summary)`** in Semantic Versioning).
2. **feat:** a commit of the *type* `feat` introduces a new feature to the codebase (this correlates with **`[MINOR](http://semver.org/#summary)`** in Semantic Versioning).
3. **BREAKING CHANGE:** a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with **`[MAJOR](http://semver.org/#summary)`** in Semantic Versioning). A BREAKING CHANGE can be part of commits of any *type*.
4. *types* other than `fix:` and `feat:` are allowed, for example **[@commitlint/config-conventional](https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional)** (based on the **[the Angular convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines)**) recommends `build:`, `chore:`, `ci:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, and others.
5. *footers* other than `BREAKING CHANGE: <description>` may be provided and follow a convention similar to **[git trailer format](https://git-scm.com/docs/git-interpret-trailers)**.

### Testing

At Stream, we value testing. Every PR should include passing tests for existing and new features. To run our test suite locally, you can use the following *melos* command:

```bash
> melos run test:dart
> melos run test:flutter
```

### Our Process

By default, our development branch is `develop`. Contributors should create new PRs based on `develop` when working on new features. 

Develop is merged into master after the team performs various automated and QA tests on the branch. Master can be considered our stable branch — it represents the latest published release on pub.dev. 

---

# Versioning Policy

All of the Stream Chat packages follow [semantic versioning (semver)](https://semver.org/).

See our [versioning policy documentation](https://getstream.io/chat/docs/sdk/flutter/basics/versioning_policy/) for more information.

---

# Styleguides 💅

![image](https://user-images.githubusercontent.com/20601437/124241186-d17a8680-db1b-11eb-9a21-3df305674ca9.png)

We use style guides and lint checks to keep our code consistent and maintain best practices. Our team uses Dart's built-in analyzer for linting and enforcing code styles. The full list of analyzer rules can be found below.

## Dart lint rules 📖

```yaml
analyzer:
  exclude:
    - packages/*/lib/**/*.g.dart
    - packages/*/example/**
    - packages/*/lib/**/*.freezed.dart
    - packages/*/test/**

linter:
  rules:
    # these rules are documented on and in the same order as
    # the Dart Lint rules page to make maintenance easier
    # https://github.com/dart-lang/linter/blob/master/example/all.yaml
    - always_use_package_imports
    - avoid_empty_else
    - avoid_relative_lib_imports
    - avoid_slow_async_io
    - avoid_types_as_parameter_names
    - cancel_subscriptions
    - close_sinks
    - control_flow_in_finally
    - empty_statements
    - hash_and_equals
    - invariant_booleans
    - iterable_contains_unrelated_type
    - list_remove_unrelated_type
    - literal_only_boolean_expressions
    - no_adjacent_strings_in_list
    - no_duplicate_case_values
    - no_logic_in_create_state
    - prefer_void_to_null
    - test_types_in_equals
    - throw_in_finally
    - unnecessary_statements
    - unrelated_type_equality_checks
    - omit_local_variable_types
    - use_key_in_widget_constructors
    - valid_regexps
    - always_declare_return_types
    - always_require_non_null_named_parameters
    - annotate_overrides
    - avoid_bool_literals_in_conditional_expressions
    - avoid_catching_errors
    - avoid_init_to_null
    - avoid_null_checks_in_equality_operators
    - avoid_positional_boolean_parameters
    - avoid_private_typedef_functions
    - avoid_redundant_argument_values
    - avoid_return_types_on_setters
    - avoid_returning_null_for_void
    - avoid_shadowing_type_parameters
    - avoid_single_cascade_in_expression_statements
    - avoid_unnecessary_containers
    - avoid_unused_constructor_parameters
    - await_only_futures
    - camel_case_extensions
    - camel_case_types
    - cascade_invocations

    - constant_identifier_names
    - curly_braces_in_flow_control_structures
    - directives_ordering
    - empty_catches
    - empty_constructor_bodies
    - exhaustive_cases
    - file_names
    - implementation_imports
    - join_return_with_assignment
    - leading_newlines_in_multiline_strings
    - library_names
    - library_prefixes
    - lines_longer_than_80_chars
    - missing_whitespace_between_adjacent_strings
    - non_constant_identifier_names
    - null_closures
    - one_member_abstracts
    - only_throw_errors
    - package_api_docs
    - package_prefixed_library_names
    - parameter_assignments
    - prefer_adjacent_string_concatenation
    - prefer_asserts_in_initializer_lists
    - prefer_asserts_with_message
    - prefer_collection_literals
    - prefer_conditional_assignment
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_constructors_over_static_methods
    - prefer_contains
    - prefer_equal_for_default_values
    - prefer_expression_function_bodies
    - prefer_final_fields
    - prefer_final_in_for_each
    - prefer_final_locals
    - prefer_function_declarations_over_variables
    - prefer_generic_function_type_aliases
    - prefer_if_elements_to_conditional_expressions
    - prefer_if_null_operators
    - prefer_initializing_formals
    - prefer_inlined_adds
    - prefer_int_literals
    - prefer_interpolation_to_compose_strings
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_is_not_operator
    - prefer_null_aware_operators
    - prefer_single_quotes
    - prefer_spread_collections
    - prefer_typing_uninitialized_variables
    - provide_deprecation_message
    - public_member_api_docs
    - recursive_getters
    - sized_box_for_whitespace
    - slash_for_doc_comments
    - sort_child_properties_last
    - sort_constructors_first
    - sort_unnamed_constructors_first

    - type_annotate_public_apis
    - type_init_formals
    - unnecessary_await_in_return
    - unnecessary_brace_in_string_interps
    - unnecessary_const
    - unnecessary_getters_setters
    - unnecessary_lambdas
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_null_in_if_null_operators
    - unnecessary_nullable_for_final_variable_declarations
    - unnecessary_parenthesis
    - unnecessary_raw_strings
    - unnecessary_string_escapes
    - unnecessary_string_interpolations
    - unnecessary_this
    - use_is_even_rather_than_modulo
    - use_late_for_private_fields_and_variables
    - use_rethrow_when_possible
    - use_setters_to_change_properties
    - use_to_and_as_if_applicable
    - package_names
    - sort_pub_dependencies

    - cast_nullable_to_non_nullable
    - unnecessary_null_checks
    - tighten_type_of_initializing_formals
    - null_check_on_nullable_type_parameter
```
