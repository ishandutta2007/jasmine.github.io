This example shows how to use Jasmine to test TypeScript code using Node's
native TypeScript support.

To run the tests in Node 24 or later: `npm test`.<br>
To run the tests in Node 22: `npm run testNode22`.

Caveats:

* You need Node 22 or later.
* The code must use only [erasable TypeScript syntax](https://devblogs.microsoft.com/typescript/announcing-typescript-5-8-beta/#the---erasablesyntaxonly-option_).
* `.ts` extensions on import specifiers are required. Although extensionless
  local imports are the dominant TypeScript style, they require transpilation.
  Node does not support them.
* Types are not checked. If you want type checking, run `tsc` separately.