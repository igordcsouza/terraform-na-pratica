# TNP 1.3 - Comecando a brincadeira

Nesse video vamos conhecer os principais comandos do terraform (`terraform init, terraform plan, terraform apply e terraform destroy`) e entender um pouco de como funcionam as variaveis.
Tambem falamos rapidamente sober o arquivo de estado.

🎥 [TNP 1.3 - Comecando a brincadeira](https://www.youtube.com/watch?v=1HhoFVtoxlU)


``mkdir terraform_digital_ocean``

``cd terraform_digital_ocean``

``vim carro.tf``

``` hcl
provider "digital_ocean"{

}
```

``terraform init``

``vim ~/.bashrc``

``` bash
alias terraform="docker run --rm -v $(pwd):/app/ -w /app/ -it hashicorp/terraform"
```

``source ~/.bashrc``

``terraform init``

``mv carro.tf main.tf``

``vim main.tf``

``` hcl
    provider "digitalocean" {
        token = ""
    }
```

``terraform init``

``vim main.tf``

``` hcl
provider "digitalocean" {
    token = ""
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
}
```

``terraform plan -out planejamento``

``terraform apply "planejamento"``

``vim terraform.tfstate``

``rm planejamento``

``vim main.tf``

``` hcl
variable "do_token" {
    default = ""
}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
}
```

``terraform apply``

``vim main.tf``

``` hcl
variable "do_token" {}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
}
```

``vim ~/.bashrc``

``` bash
alias terraform="docker run --rm -v $(pwd):/app/ -w /app/ -e TF_VAR_do_token="" -it hashicorp/terraform"
```

``source ~/.bashrc``

``terraform plan``

``terraform apply``

``vim ~/.bashrc``

``` bash
export DIGITALOCEAN_TOKEN=""

alias terraform="docker run --rm -v $(pwd):/app/ -w /app/ -e DIGITALOCEAN_TOKEN=$DIGITALOCEAN_TOKEN -it hashicorp/terraform"
```

``source ~/.bashrc``


``vim main.tf``

``` hcl
provider "digitalocean" {}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
}
```

``terraform destroy``

---

[Inicio](/README.md)
