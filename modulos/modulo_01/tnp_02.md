# TNP 1.2 - Executando o Terraform com Docker containers

🎥 [TNP 1.2 - Executando o Terraform com Docker containers](https://www.youtube.com/watch?v=1HhoFVtoxlU)

Comandos utilizados nesse video:

```sh
sudo yum update -y
curl -fsSL https://get.docker.com | sh;
sudo systemctl status docker
sudo systemctl start docker
sudo systemctl status docker
docker images
sudo usermod -aG docker vagrant
logoff to vm
login to vm
docker --version
docker images
docker pull hashicorp/terraform:latest
docker run -it hashicorp/terraform --version
sudo yum install vim -y
vim ~/.bashrc
echo 'alias terraform="docker run --rm -it hashicorp/terraform"' >> ~/.bashrc
cat ~/.bashrc
terraform --version
source ~/.bashrc
terraform --version
echo 'alias terraform-old="docker run --rm -it hashicorp/terraform:0.11.14"' >> ~/.bashrc
source ~/.bashrc
terraform-old --version
```

Explicação sobre o parâmetro `--rm` 

🎥 [TNP 1.2.1 - Adicionando comando para remover o container!](https://www.youtube.com/watch?v=osy_yz7lh1k)

>❗ Sugestão: para não acumular um monte de container a cada execução do comando terraform adicionar o flag --rm https://docs.docker.com/engine/reference/run/#clean-up---rm

```sh
 echo 'alias terraform="docker run --rm -it hashicorp/terraform"' >> ~/.bashrc
```




---

[Inicio](/README.md)


