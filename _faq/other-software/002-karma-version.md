---
question: Why don't newer Jasmine features work in Karma?
---

karma-jasmine has been unmaintained since 2022. It depends on jasmine-core 4.x.
As a result, Karma will use jasmine-core 4.x even if you've installed a newer
version.

You should migrate to a maintained alternative such as jasmine-browser-runner or 
[web-test-runner-jasmine](https://www.npmjs.com/package/web-test-runner-jasmine).
If you really want to keep using Karma, you should be able to override 
karma-jasmine's dependency specification in your `package.json` file:

```
{
    // ...
    "overrides": {
        "karma-jasmine": {
            "jasmine-core": "^6.0.0"
        }
    }
}
```

This will work for jasmine-core 5.x and 6.x, but not newer versions. 6.x is the
final major version that karma-jasmine is compatible with.