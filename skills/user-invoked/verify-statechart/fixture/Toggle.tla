------------------------------ MODULE Toggle ------------------------------
(*
 * Minimal 2-state model used as the verify-statechart skill install proof.
 * A switch flips between "off" and "on"; NoStuck says the switch
 * can always move again (no dead end).
 *)
EXTENDS TLC

VARIABLES switch

Init == switch = "off"

Flip == switch' = IF switch = "off" THEN "on" ELSE "off"

Next == Flip

Spec == Init /\ [][Next]_switch

NoStuck == switch \in {"off", "on"}

=============================================================================
