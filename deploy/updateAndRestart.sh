


DIR="/home/ubuntu/deploy/sa_g2_2s2019"

echo "Cambiando a /home/ubuntu"
cd /home/ubuntu/deploy
echo "Entrando en proyecto"



if [ -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "Installing config files in ${DIR}..."
  echo "Apagando servicios si no lo estan"
  cd /home/ubuntu/deploy/sa_g2_2s2019
  docker-compose down
  echo "Eliminando proyecto"
  sudo rm -rf /home/ubuntu/deploy/sa_g2_2s2019
  cd ..
fi
#test 1


echo "Clonando proyecto"
git clone https://mike_talavera:Mike1992%40@gitlab.com/Plata346/sa_g2_2s2019.git
echo "Entrando en proyecto"
cd sa_g2_2s2019
echo "Levantando servicios"
docker-compose up -d  