package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"

	"strings"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	ssh_helper "github.com/gruntwork-io/terratest/modules/ssh"

	"os"
)

func TestTerraformAsgWeb(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../aws-terraform-asg-web",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions) // the data-aws_instance seems to require two terraform apply to become populated. How to resolve

	output := terraform.Output(t, terraformOptions, "alb_dns_name")
	assert.True(t, strings.Contains(output, "elb.amazonaws.com"), "The lb url is %s", output)

	url := fmt.Sprintf("http://%s", output)
	validateFunc := func(status int, responseBody string) bool {
		return status == 200 && strings.Contains(responseBody, "Hello from")
	}
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, 10, 5*time.Second, validateFunc)

	associate_public_ip_address := terraform.Output(t, terraformOptions, "associate_public_ip_address") == "true"

	if associate_public_ip_address {
		public_ips := terraform.OutputList(t, terraformOptions, "instance_state_pubip")
		fmt.Println("Hello world", public_ips)
		homeDir, err := os.UserHomeDir()
		if err != nil {
			panic("Unable to read user home path")
		}
		myPrivateKeyString, err := os.ReadFile(homeDir + "/.ssh/Test.pem")
		if err != nil {
			panic("Unable to read ssh key file")
		}
		keypair := ssh_helper.KeyPair{PrivateKey: string(myPrivateKeyString)}
		// Let's just check the first ip
		publicHost := ssh_helper.Host{
			Hostname:    public_ips[0],
			SshKeyPair:  &keypair,
			SshUserName: "ec2-user",
		}
		ssh_helper.CheckSshConnectionWithRetry(t, publicHost, 10, 5*time.Second)

	} else {
		fmt.Println("Public IPs have not been assigned. Skipping test...")
	}
}

// Test ssh to ec2 instance
// Test http with lb url
// TODO Test with public ip4 off
