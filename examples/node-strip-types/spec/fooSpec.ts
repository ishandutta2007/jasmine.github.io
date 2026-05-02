import {foo} from "../lib/foo.ts";

describe('foo', function() {
    it('returns 42', function() {
        expect(foo()).toEqual(42);
    });
});