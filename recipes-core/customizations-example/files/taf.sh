if [[ ! -f /etc/qbee/qbee-agent.json ]]
then
  RENAMED=""
  while [[ $RENAMED != [sSnN] ]]
  do
    read -p "O nome do dispositivo ($(hostname)) está correto (s|n)? " RENAMED
  done

  if [[ $RENAMED == [nN] ]]
  then
    echo "1. Execute o comando: iot2050setup"
    echo "2. Entre em "
    echo "3. Entre em "
    echo "4. Insira o nome correto do dispositivo em "
    echo "5. Saia do utilitário iot2050setup"
    echo "6. Execute o comando: reboot now"
    echo "7. Após reinicialização, execute o comando: ~/taf.sh"
    exit 1
  fi

  QBEE_BOOTSTRAP_KEY=""
  while [ -z $QBEE_BOOTSTRAP_KEY ]
  do
    read -p "Insira a bootstrap key: " QBEE_BOOTSTRAP_KEY
  done
  qbee-agent bootstrap -k "${QBEE_BOOTSTRAP_KEY}" > /dev/null 2>&1 && systemctl start qbee-agent > /dev/null 2>&1
fi


SSH_PATH=/etc/ssh/ssh_config.d/yot-iot


if [ ! -f "${SSH_PATH}" ] || [ ! -f "${SSH_PATH}.pub" ]
then
  ssh-keygen -q -t ed25519 -f "${SSH_PATH}" -N '' <<< y > /dev/null 2>&1
fi


if [ ! -f "${SSH_PATH}.conf" ]
then
  echo "Host yot-iot
    Hostname github.com
    IdentityFile=/etc/ssh/ssh_config.d/yot-iot
  " > "${SSH_PATH}.conf"
fi


if [ ! -f ~/.ssh/known_hosts ]
then
  touch ~/.ssh/known_hosts
fi


ssh-keygen -F github.com > /dev/null 2>&1
if [ $? -eq 1 ]
then
  ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts 2>&1
fi


if [ ! -d ~/yot-iot ]
then
  {
    git clone -q git@yot-iot:greylogixbrasil/yot-iot.git ~/yot-iot > /dev/null 2>&1
  } || {
    echo "1. Acesse o endereço https://github.com/greylogixbrasil/yot-iot/settings/keys"
    echo "2. Clique em \"Add deploy key\""
    echo "3. Cole a seguinte chave no campo \"Key\" $(cat "${SSH_PATH}.pub")"
    echo "4. Clique em \"Add key\""
    echo "5. Execute o comando: ~/taf.sh"
    exit 1
  }
fi


cd ~/yot-iot
if [ ! -f .env ]
then
  cp sample.env .env
fi


chown -R 1000:1000 .node-red


docker compose up -d
