if [[ $(whoami) != "root" ]]; then
  echo "Este script deve ser executado pelo root"
  exit 1
fi


GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'
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


if [[ ! -f /etc/qbee/qbee-agent.json ]]
then
  RENAMED=""
  while [[ $RENAMED != [sSnN] ]]
  do
    read -p "O nome do dispositivo ($(hostname)) está correto (s|n)? " RENAMED
  done

  if [[ $RENAMED == [nN] ]]
  then
    echo -e "1. Execute o comando ${YELLOW}iot2050setup${NO_COLOR}"
    echo -e "2. Entre em ${YELLOW}OS Settings${NO_COLOR}"
    echo -e "3. Entre em ${YELLOW}Change Hostname${NO_COLOR}"
    echo -e "4. Insira o nome correto do dispositivo em ${YELLOW}Host Name${NO_COLOR}"
    echo -e "5. Saia do utilitário iot2050setup"
    echo -e "6. Execute o comando ${YELLOW}reboot now${NO_COLOR}"
    echo -e "7. Após reinicialização, execute o comando ${YELLOW}~/taf.sh${NO_COLOR}"
    exit 1
  fi

  QBEE_BOOTSTRAP_KEY=""
  while [ -z $QBEE_BOOTSTRAP_KEY ]
  do
    read -p "Insira a bootstrap key: " QBEE_BOOTSTRAP_KEY
  done
  {
    qbee-agent bootstrap -k "${QBEE_BOOTSTRAP_KEY}" > /dev/null 2>&1 && systemctl restart qbee-agent > /dev/null 2>&1
  } || {
    echo -e "Certifique a conexão com a internet."
    exit 1
  }
fi


if [ ! -d ~/yot-iot ]
then
  {
    git clone -q git@yot-iot:greylogixbrasil/yot-iot.git ~/yot-iot > /dev/null 2>&1
  } || {
    echo -e "1. Acesse o endereço ${YELLOW}https://github.com/greylogixbrasil/yot-iot/settings/keys${NO_COLOR}"
    echo -e "2. Clique em ${YELLOW}Add deploy key${NO_COLOR}"
    echo -e "3. Cole a seguinte chave no campo ${YELLOW}Key${NO_COLOR} ${GREEN}$(cat "${SSH_PATH}.pub")${NO_COLOR}"
    echo -e "4. Clique em ${YELLOW}Add key${NO_COLOR}"
    echo -e "5. Execute o comando: ${YELLOW}~/taf.sh${NO_COLOR}"
    exit 1
  }
fi


cd ~/yot-iot
if [ ! -f .env ]
then
  cp sample.env .env
fi


docker compose up -d
