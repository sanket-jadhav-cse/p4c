# Assignment Index Evaluation Bug

## Root cause
Indexed assignment destinations are evaluated after RHS
side effects, causing writes to the wrong header-stack element.

## Example
h.stack[index].value = update(index);

## Severity
High - silent compiler miscompilation and packet-data corruption.

## Specification
P4_16 v1.2.5, Section 12.1.

## Base commit
928105a50fe5ebea4f7e9fe3bd4a9428fd57490a

## Original branch
fix/assignment-index-evaluation

## Production files
frontends/p4/sideEffects.cpp
frontends/p4/sideEffects.h

## Regression evidence reported
- Baseline packet regression: FAIL
- Fixed packet regression: PASS
- Independent p4test result: 10 -> 42
- Focused CTest: 7/7 PASS
- clang-format, cpplint, REUSE: PASS
- git diff --check: PASS
- Full backend suites: Not run

## Duplicate analysis
No matching duplicate was found in the original search.
Related issues and PRs: #5860, #5472, #4853.

## Suggested PR title
Preserve assignment indices across RHS side effects
