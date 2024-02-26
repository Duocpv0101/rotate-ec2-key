#!/bin/bash

#Install SSM Agent
ssm_status=$(systemctl is-active amazon-ssm-agent)
if [[ "$ssm_status" == "active" ]]; then
    echo "SSM Agent is already installed."
else
    if [[ "$ssm_status" == "inactive" ]]; then
    sudo systemctl start amazon-ssm-agent
    else
        echo "Installing SSM Agent..."
        sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
        sudo systemctl enable amazon-ssm-agent
        sudo systemctl start amazon-ssm-agent
    fi
fi

#Check SSM Agent install
ssm_status=$(systemctl is-active amazon-ssm-agent)
if [[ "$ssm_status" == "active" ]]; then
    echo "SSM Agent has been installed and started successfully."
else
    echo "Failed to install SSM Agent."
    exit 0
fi