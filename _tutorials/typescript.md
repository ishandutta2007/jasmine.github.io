---
layout: article
title: Testing TypeScript code
---

# Testing TypeScript code

<div class="warning">Note: This tutorial deals with a rapidly changing area and
may become out of date. It was last updated in May 2026.</div>

Jasmine can be used to test TypeScript code. Unfortunately, the TypeScript
ecosystem is quite fragmented. There is no one Jasmine configuration that works 
for all TypeScript projects. Setting up Jasmine to test some TypeScript projects
can be easy. For others, you might need to understand your dialect of 
TypeScript and how your build tooling turns it into JavaScript.

## Summary of options

Depending on the TypeScript dialect you're using and how you weigh various
trade-offs, you might be able to:

* Translate TypeScript to JavaScript at module load time and test in Node
* Use Node's native TypeScript support
* Compile to JavaScript files on disk and test in Node or browsers
* Use Web Test Runner

Except for Node's native TypeScript support, all of those options involve
turning TypeScript code into valid JavaScript code that your browser or Node can
execute. Any resulting syntax errors, import errors, etc. are almost always
due to problems with the TypeScript toolchain or the code being compiled, not
Jasmine-specific issues.

## Translate TypeScript to JavaScript at module load time and test in Node

This is the most popular way to test TypeScript code. It involves configuring a
Node module loader to translate TypeScript to JavaScript when modules are 
loaded. This approach provides a fast edit-compile-run cycle but doesn't do any
type checking.

There is no one module loader that works for all TypeScript dialects. Common
choices include [`@babel/register`](https://www.npmjs.com/package/@babel/register)
for testing code that works with the official TypeScript compiler and
[`tsx`](https://www.npmjs.com/package/tsx) for code that uses Vite/ESBuild
specific syntax.

If you use a CommonJS module loader, you can install it in a helper file that
loads before any of your TypeScript code. See 
[Testing a React app in Node.js](./react_with_node)
for an example of wiring up `@babel.register` that way. The process for
installing an ES module loader differs from one Node version to the next, but
generally involves running `node <args that install the loader> ./node_modules/.bin/jasmine`.
See the [Node documentation](https://nodejs.org/api/module.html#customization-hooks)
for more information.

## Use Node's native TypeScript support

Newer versions of Node are able to load and run TypeScript code directly. This
approach requires the least setup and provides a fast edit-compile-run cycle but
isn't compatible with all TypeScript codebases and does not do any type checking.
You may be able to use it if all the following apply:

* You're running Node 22 or later
* All local import specifiers use file extensions (e.g. 
  `import {foo} from "./foo.ts"` rather than `import {foo} from "./foo"`)
* You use only [erasable TypeScript syntax](https://www.typescriptlang.org/tsconfig/#erasableSyntaxOnly)

To use native TypeScript support, set `spec_files` in your Jasmine configuration
file to something that matches your TypeScript files, such as
`spec_files: ["**/*[sS]pec.ts"]`. If you're running Node 24 or later, you can
run `jasmine` as usual. For Node 22, run 
`node --experimental-strip-types ./node_modules/.bin/jasmine`.

A [complete working example](https://github.com/jasmine/jasmine.github.io/tree/master/examples/node-strip-types)
of this setup is available.

## Compile to JavaScript files on disk and test in Node or browsers

This approach provides a slower edit-compile-run cycle than the previous options
but gives type checking "for free" and may be the easiest to set up if you
already compile your non-test TypeScript code to individual JavaScript files.

The usual approach is to create a second tsconfig file that compiles tests as
well as the code under test, and use `tsc` to build it before each Jasmine run.
Source and spec file globs in the `jasmine` or `jasmine-browser-runner` config
file should refer to the compiled JavaScript files, not the TypeScript files.

## Use Web Test Runner

Web Test Runner supports TypeScript via the [esbuild plugin](https://modern-web.dev/docs/dev-server/plugins/esbuild/)
and Jasmine via [web-test-runner-jasmine](https://www.npmjs.com/package/web-test-runner-jasmine).

## Type checking

If you want to add type checking to any of the above approaches, you can create
a separate TypeScript config file for your specs with `noEmit` set to `true`.
Then run `tsc` on it either before or after running your specs.

## Vite-specific extensions and other issues

TypeScript users commonly use language extensions that are not part of
TypeScript itself. Common examples include CSS "imports" that are stripped at 
compile time and used to configure a CSS build process, JSON "imports" that are
replaced with the contents of the JSON file at compile time, compile-time
substitution of environment variables into `process.env`, and Vite's 
`import.meta`. To test code that uses those extensions, you'll need to find a
way to turn them into valid JavaScript that works in a testing context.

If you're compiling to JavaScript files on disk, consult your TypeScript build
tool's documentation. If you're using Node's native TypeScript support or using
a module loader to translate TypeScript to JavaScript, you may be able to use
additional module loaders to deal with the nonstandard features. For instance,
the [ignore-styles](https://github.com/bkonkle/ignore-styles) CommonJS loader
can turn CSS imports into no-ops. The selection of custom ES module loaders for
purposes like this is, unfortunately, more limited. You may need to write your
own. See the [Node documentation](https://nodejs.org/api/module.html#customization-hooks)
for more information.

The best way to deal with features like `process.env` substitution and
`import.meta` may be to use dependency injection to decouple the code that
you're testing from them.

