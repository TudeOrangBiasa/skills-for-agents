# Foggy brief: team notifications (fixture for test-plan-map-handoff.sh)

The way to the destination is not visible in one session: channels,
volume caps, and the audit trail all hang on open decisions.

## Destination (settled on the map)

Team leads get one digest per channel per day, with an audit trail.

## Decisions-so-far (settled on the map)

- Digest over realtime: one send per channel per day.
- Every send writes an audit row before dispatch.

## Not-yet-specified (fog to clear)

- Which channels qualify for a digest.
- Retry policy when a channel send fails.
