echo "this is my first github action" | tee hello
ls -lta
sudo apt-get install -y cowsay
cowsay -f dragon "hello cover me" >>hello
cat hello
