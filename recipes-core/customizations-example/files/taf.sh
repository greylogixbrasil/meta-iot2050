RENAMED=""


while [[ $RENAMED != [sSnN] ]]
do
  read -p "O nome do dispositivo ($(hostname)) está correto (s|n)? " RENAMED
done


if [[ $RENAMED == [sS] ]]
then
  if [[ -f /etc/qbee/qbee-agent.json ]]
  then
    echo "O bootstrap já foi feito anteriormente."
  else
    QBEE_BOOTSTRAP_KEY=""
    while [ -z $QBEE_BOOTSTRAP_KEY ]
    do
      read -p "Insira a bootstrap key: " QBEE_BOOTSTRAP_KEY
    done
    qbee-agent bootstrap -k "${QBEE_BOOTSTRAP_KEY}" && systemctl start qbee-agent 
  fi
else
  echo "1. Execute o comando: iot2050setup"
  echo "2. Entre em "
  echo "3. Entre em "
  echo "4. Insira o nome correto do dispositivo em "
  echo "5. Saia do utilitário iot2050setup"
  echo "6. Execute o comando: reboot now"
  echo "7. Após reinicialização, execute o comando: ~/taf.sh"
  exit 0
fi


if [ -d ~/yot-iot ]
then
  cd ~/yot-iot && docker compose up -d
else
  ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_config.d/yot-iot -N '' <<< y > /dev/null 2>&1

  echo "Host yot-iot
    Hostname github.com
    IdentityFile=/etc/ssh/ssh_config.d/yot-iot
  " > /etc/ssh/ssh_config.d/yot-iot.conf

  echo "1. Acesse o endereço https://github.com/greylogixbrasil/yot-iot/settings/keys"
  echo "2. Clique em \"Add deploy key\""
  echo "3. Cole a seguinte chave no campo \"Key\" $(cat /etc/ssh/ssh_config.d/yot-iot.pub)"
  echo "4. Clique em \"Add key\""
  echo "5. Execute o comando: ~/taf.sh"
fi
