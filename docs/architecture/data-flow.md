# Conceptual Data Flow

Status: Conceptual — no runtime interfaces or ROS 2 topics exist yet.

## Command Flow

An authorized operator or future mission client submits a high-level mission
request. The mission manager validates its state and sends an objective to
guidance. Guidance produces a bounded, timestamped motion request. The safety
supervisor checks freshness, vehicle state, geofence, operating limits, battery,
component health, and active failsafes. Only an approved request may proceed to
the PX4 integration boundary. Rejections and cancellations are explicit events.

Perception observations may influence mission management or guidance, but they
cannot become actuator or motor commands and cannot skip safety supervision.

## Sensor Data Flow

Gazebo simulation sensors provide timestamped data to the planned perception and
state-estimation consumers. Perception emits observations, confidence, and health
status. Target loss, low confidence, stale input, and timeouts remain explicit
conditions rather than implicit null values.

## Telemetry Flow

Critical modules publish read-only state changes and events to telemetry. The
planned record includes request provenance, approvals, rejections, mission state,
vehicle health, component health, and relevant simulation conditions. Telemetry
is observable but is not a command channel.

## Safety Event Flow

The safety supervisor consumes fault and health signals and emits explicit safety
events. Communication loss, target loss, low battery, geofence violation,
invalid command, stale telemetry, and component unavailability are distinct
states. Mission management and the flight-control integration respond through
defined transitions such as cancellation, hold, return-to-home, or safe landing,
subject to later scenario-specific validation.

## Security Event Flow

The security monitor observes validation failures, command metadata, replay
indicators, configuration integrity, and component health. It emits alerts and
risk signals to telemetry and defined safety interfaces. It does not gain an
alternate flight-control path.

Exact ROS 2 topic, service, action, and message names will be designed during
implementation after ROS 2 Jazzy is verified. This document intentionally does
not invent interfaces before their semantics and quality-of-service requirements
can be tested.
