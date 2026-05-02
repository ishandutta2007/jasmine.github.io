import {bar} from "./bar.ts";

export function foo(): number {
    return bar() + 1;
}