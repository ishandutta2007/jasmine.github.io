---
question: How do I work on a feature that depends on something that's missing from some supported environments?
---

We try to make all features of Jasmine available on all supported browsers and
Node versions, but sometimes that doesn't make sense. For instance, support for
promise-returning specs was added in 2.7.0 even though Jasmine continued to run
in environments that lacked promises until 4.0.0. To write a spec for something
that won't work in all environments, check whether the required
language/runtime features are present and call `notApplicable()` if they're not.
See [spec/helpers/environments.js](https://github.com/jasmine/jasmine/blob/bf290015b2a8cf1cdb363ea048ee59a1b2692925/spec/helpers/environments.js)
and the uses of the functions that it defines for an example of how to do this.

See the is\* methods in
[src/core/base.js](https://github.com/jasmine/jasmine/blob/main/src/core/base.js)
for examples of how to safely check whether an object is an instance of a type
that might not exist.
