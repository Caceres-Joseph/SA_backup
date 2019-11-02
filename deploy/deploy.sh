set -e

# Lets write the public key of our aws instance
eval $(ssh-agent -s)
echo "$KY" | tr -d '\r' | ssh-add - > /dev/null

mkdir -p ~/.ssh
touch ~/.ssh/config
echo -e "Host *\n\tStrictHostKeyChecking no\n\n" >> ~/.ssh/config


DEPLOY_SERVER=$SER

# our substring is "," and we replace it with nothing.
ALL_SERVERS=(${DEPLOY_SERVERS//,/ })
echo "ALL_SERVER ${ALL_SERVERS}"

#for server in "${ALL_SERVERS[@]}"
#do
  echo "deploying to ${server}"
  ssh ubuntu@${DEPLOY_SERVER} 'bash' < ./deploy/updateAndRestart.sh
#done



