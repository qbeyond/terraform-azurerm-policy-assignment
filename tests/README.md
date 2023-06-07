# Tests

This folder contains tests using terraforms conditions. You should be able to run `terraform apply`. Another `terraform apply` should not change anything. `terraform destroy` should destroy any resource without a problem. 

Tests in `main.tf` just deploys possible combinations of the module. The keys of the used maps indicate the tested combination.

Tests for special cases are split into files with meaningfull names and errormessages.

Subfolders `fail_*` containing tests that are expected to fail with expected errors in the `README.md`.