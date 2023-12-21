echo "this is my first github action" | tee hello
ls -lta
sudo apt-get install -y cowsay
cowsay -f dragon "dragon cover me" >>hello
cat hello
