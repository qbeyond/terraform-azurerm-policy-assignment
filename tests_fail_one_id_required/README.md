# One id is required

The module declares `policy_definition_id` and `policy_set_definition_id` as optional, but one of them is required and the other one must be null. 

## Expected fails

You should receive two errors for the modules:

- `` `policy_set_definition_id` or `policy_definition_id` is required. ``
- `` Only `policy_set_definition_id` or `policy_definition_id` is allowed. ``