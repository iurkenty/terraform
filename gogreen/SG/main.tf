#to fetch the output value from a remote state file use the following
#cidr_blocks      = ["${data(function).terraform_remote_state(data block name).eip(resource).outputs(command).eip_addr(name)}/32"]