# Backend samples

Each folder demonstrates the same analytics contract in a different language.

The intent is not to run every backend at the same time. The intent is to provide a consistent reference shape that can be copied into a project repository for the target stack.

## Common rules

- normalize input first
- pseudonymize sensitive identifiers
- store append-only event records when possible
- aggregate into summary statistics
- avoid collecting data that is not needed for the use case
