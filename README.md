# aws-terraform-asg-web
Demo of an Auto-Scaling Group with Web servers

# terratest

N.B. These tests will recreate and then destroy the defined resources in AWS.

```bash
cd test/
export GO111MODULE=on
go mod init test
go mod tidy
go test -v -timeout 30m
```

N.B. The above should work on it's own but there's an issue here I still need to resolve.
There's a problem with the data.aws_instances provider that seems to require a second run to populate the info.
Therefore the procedure, until this is fixed, is...

```bash
terraform apply
terraform apply
# Then the instance_state_pubip output will be populated and the test will run
cd test/
go mod init test
go mod tidy
go test -v -timeout 30m
```

# TODO

* Fix ip address outputs - Fix with depends_on in aws_instances data resources.
* Restructure / Divide up tests, ideally; setup, test1..n, teardown
* Test with public ip4 off / ssh fail - Doesn't work with public IP off. Do I need a NAT Getweay?

