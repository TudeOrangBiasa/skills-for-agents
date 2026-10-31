# Separate Before Serializing Shared State

Concurrent actors sharing one mutable file, branch, key, or object get separate owned targets first.

Ask whether they need one canonical object or are publishing independent facts. If independent, give each actor its own file, key, branch, or state directory, merged only at read time. Serialize structurally (lockfiles, sequential phases, single writer) only when one shared target is a real invariant. Instructions are not concurrency control.

## Why

Concurrent writes to shared state create races that are intermittent, hard to reproduce, and expensive to debug. A lock fixes the corruption but keeps the coupling: every actor still contends on one object and every schedule change reopens the question. Separation deletes the race instead of managing it, and leaves each actor's output readable on its own when something goes wrong.

## When it applies

- Two or more actors (workers, delegates, ticks, jobs) might write to the same mutable target.
- Default to eliminating the shared target. Two workers writing their own field into one `state.json` is still shared mutation; two state files merged at read time is not.
- Treat "we need a lock" as a design smell to check, not the default answer. Reach for lockfiles, sequential phases, or a single writer only after confirming the sharing is real.

## Example in this repo

Releases never ask concurrent PRs to edit one changelog. Each change ships its own file under `.changeset/`, and the changelog is merged from those files at release time. Parallel work slices follow the same shape: each slice owns its worktree and lands independently, and integration reads them together at the end.
