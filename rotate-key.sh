#!/bin/bash

# Input
HOST=`cat input.txt |grep HOST|awk '{print $2'}`
USER=`cat input.txt |grep USERNAME|awk '{print $2'}`
KEY_NAME=`cat input.txt |grep NEWKEY|awk '{print $2'}`
OLD_KEY=`cat input.txt |grep OLDKEY|awk '{print $2'}`

#Create New keypair
echo "################################"
NEW_KEY_NAME=$KEY_NAME-$(date +"%H%M%S-%d%m%Y")
echo "Generating RSA key pair..."
ssh-keygen -t rsa -b 2048 -f $NEW_KEY_NAME -N ""
echo '--------------------------------------'
echo "RSA key pair generated:"
echo "Private key: $NEW_KEY_NAME"
echo "Public key: $NEW_KEY_NAME.pub"

#Rotate KeyPair
echo "#################################"
echo "Rotate KeyPair"
scp -i $OLD_KEY -o StrictHostKeyChecking=no $NEW_KEY_NAME.pub $USER@$HOST:~.ssh
ssh -i $OLD_KEY -o StrictHostKeyChecking=no $USER@$HOST 'cp .ssh/authorized_keys .ssh/authorized_keys.bak'
ssh -i $OLD_KEY -o StrictHostKeyChecking=no $USER@$HOST 'cp .ssh/authorized_keys .ssh/authorized_keys.change'
ssh -i $OLD_KEY -o StrictHostKeyChecking=no $USER@$HOST 'cat .ssh/*.pub > .ssh/authorized_keys.change'
ssh -i $OLD_KEY -o StrictHostKeyChecking=no $USER@$HOST 'cp .ssh/authorized_keys.change .ssh/authorized_keys'

echo '#################################'
echo "Test SSH with New key"
echo "Loading...."
ssh -i $NEW_KEY_NAME -o StrictHostKeyChecking=no $USER@$HOST 'rm -rf .ssh/*.pub'
if [ $? -eq 0 ]; then
    echo "SSH Successfull"
else
    echo "SSH not successfull"
fi