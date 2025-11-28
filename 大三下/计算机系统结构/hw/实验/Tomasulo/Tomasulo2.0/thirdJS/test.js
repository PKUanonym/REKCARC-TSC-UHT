// Bootstrap ReDoS Fix Verification
// Fixed regex: /^[^#]*(?=#[^\s]+$)/

console.log("=== Bootstrap ScrollSpy - Fixed Version Test ===\n");

// Fixed function with patched regex
const fixedFunction = function(href) {
    //return href.replace(/.*(?=#[^\s]*$)/, '')
    return href.replace(/^[^#]*(?=#[^\s]+$)/, '') //fixed
};

// Functional tests
console.log("Functional Tests:");
const tests = [
    { input: "http://example.com#section", expected: "#section" },
    { input: "page.html#anchor", expected: "#anchor" },
    { input: "noanchor", expected: "" }
];

tests.forEach(test => {
    const result = fixedFunction(test.input);
    console.log(`  ${result === test.expected ? '✓' : '✗'} ${test.input} => ${result}`);
});

// ReDoS attack tests
console.log("\nReDoS Prevention Tests:");
const attacks = [
    { desc: '"\\u0000" * 100000 + "\\u0000"', payload: "\u0000".repeat(100000) + "\u0000" },
    { desc: '"1" * 100000 + "\\n@"', payload: "1".repeat(100000) + "\n@" },
    { desc: '"=" + "#" * 100000 + "@\\r"', payload: "=" + "#".repeat(100000) + "@\r" },
    { desc: '"=#" * 100000 + "@\\r"', payload: "=#".repeat(100000) + "@\r" }
];

let maxTime = 0;
attacks.forEach((attack, i) => {
    const start = Date.now();
    fixedFunction(attack.payload);
    const time = Date.now() - start;
    maxTime = Math.max(maxTime, time);
    console.log(`  Test ${i + 1}: ${time} ms ${time < 100 ? '✓ SAFE' : '⚠ SLOW'}`);
});

console.log(`\n${maxTime < 100 ? '✓ ReDoS Fixed!' : '⚠ Still vulnerable'}`);
console.log(`Max time: ${maxTime} ms (should be < 100ms)`);