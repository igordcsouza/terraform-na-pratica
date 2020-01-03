# TNP 1.4 - Arquivo de Estado! Amor ou Ódio?

Numa conta zerada é simples de acessar o painel de controle e ver o que criamos, mas como fazer isso sem precisar acessar o painel de controle?

Vamos conhecer essa `feature` do Terraform que é motivo de muito amor e ódio dentro da comunidade! 

Nesse vídeo vamos entender um pouco como ela pode ser utilizada e até criarmos alguns problemas para ver como ela se comporta!

🎥 [TNP 1.4 - Arquivo de Estado! Amor ou Ódio?]()

1. O que é o [arquivo de estado](https://www.terraform.io/docs/state/)?
1. Como exibir conteudo do arquivo de estado.
1. Alguns problemas:
    * Se você perder o arquivo, vai precisar importar os recursos.
    * Múltiplos usuários podem acabar alterando o arquivo ao mesmo tempo.
    * Precisa compartilhar com outras pessoas.
    * Armazena senhas passadas para execução. 
1. Importando recursos.
    * Importando o droplet perdido!
1. Arquivo remoto
    * Migrando nosso arquivo de estado para o [app.terraform.io](https://app.terraform.io)
    * Como e por que travar nosso arquivo de estado.
    * Visualizando o historico.

---
## 1.4.1
Se você prestar bastante atenção na pasta onde o nossos arquivos .tf estão, vai perceber que o terraform criou um arquivo chamado `terraform.tfstate`. 
Esse arquivo é *muito* importante na utilização do Terraform pois é nele que armazenamos o estado atual da nossa infraestrutura.

O arquivo é tão importante que é considerado por muitos um problema do Terraform pois no caso de perdermos esse arquivo, a princípio, quando rodarmos novamente o terraform apply novas máquinas serão criadas, mesmo que já existam máquinas criadas. 

Ou seja, se voce perder o seu arquivo de estado perdera o controle de tudo que foi criado com a ferramenta, nada sera deletado mas tambem nao sera possivel continuar gerenciando os recursos, pois o terraform não vai ter conhecimento de que foi ele que as criou. E isso é válido também para o terraform destroy que não conseguiria destruir sua infra pelo mesmo motivo.

Também é um certo problema caso precise utilizar o terraform de forma distribuída, entre os membros da sua equipe, ja que commitar o codigo traria muitos problemas como armazenar senhas ou mesmo multiplos acessos ao arquivo no caso de utilizar um arquivo compartilhado.

Vamos entender melhor sobre como resolver isso quando falarmos sobre arquivo remoto.

## 1.4.2

Considerando que voce ja criou algum droplet com o seu arquivo `terraform` vamos exibir o conteudo do nosso `tfstate`.

A primeira coisa que voce provavelmente fez foi algo como:

```
cat terraform.tfstate
```

Que deve ter retornado algo parecido com:

```
{
  "version": 4,
  "terraform_version": "0.12.12",
  "serial": 2,
  "lineage": "bb423728-2dde-8d06-1d23-82b18f97ade1",
  "outputs": {
    "workstation_ip": {
      "value": "138.197.99.100",
      "type": "string"
    }
  },
  "resources": [
    {
      "mode": "managed",
      "type": "digitalocean_droplet",
      "name": "workstation",
      "provider": "provider.digitalocean",
      "instances": [
        {
          "schema_version": 1,
          "attributes": {
            "backups": false,
            "created_at": "2020-01-02T23:00:56Z",
            "disk": 25,
            "id": "173975496",
            "image": "centos-7-x64",
            "ipv4_address": "138.197.99.100",
            "ipv4_address_private": "",
            "ipv6": false,
            "ipv6_address": "",
            "ipv6_address_private": null,
            "locked": false,
            "memory": 1024,
            "monitoring": false,
            "name": "TPN",
            "price_hourly": 0.00744,
            "price_monthly": 5,
            "private_networking": false,
            "region": "nyc3",
            "resize_disk": true,
            "size": "s-1vcpu-1gb",
            "ssh_keys": [
              "35:46:8e:d2:33:5d:27:ce:84:c5:8b:6a:e1:30:aa:50"
            ],
            "status": "active",
            "tags": null,
            "urn": "do:droplet:173975496",
            "user_data": null,
            "vcpus": 1,
            "volume_ids": []
          },
          "private": "eyJzY2hlbWFfdmVyc2lvbiI6IjEifQ=="
        }
      ]
    }
  ]
}

```

Nao e uma forma errada de olhar, mas pensando em uma arquivo gigante como normalmente fica provavelmente seria bem complicado de se ler. Eu gosto desse tipo de visao pois ele passa alguns dados que voce nem sequer passou pra ele. Como por exemplo o custo por hora da nossa instancia.

Mas no nosso caso, o que vamos precisar para videos futuros e basicamente o nome do recurso e ja aqui no comeco vemos a importancia de dar um nome que faca sentido para cada um dos seus recursos.

Vamos dar uma olhada no comando `terraform state`.

```
~> terraform state --help

Usage: terraform state <subcommand> [options] [args]

  This command has subcommands for advanced state management.

  These subcommands can be used to slice and dice the Terraform state.
  This is sometimes necessary in advanced cases. For your safety, all
  state management commands that modify the state create a timestamped
  backup of the state prior to making modifications.

  The structure and output of the commands is specifically tailored to work
  well with the common Unix utilities such as grep, awk, etc. We recommend
  using those tools to perform more advanced state tasks.

Subcommands:
    list    List resources in the state
    mv      Move an item in the state
    pull    Pull current state and output to stdout
    push    Update remote state from a local state file
    rm      Remove instances from the state
    show    Show a resource in the state
```

Nao vamos ver cada um dos comandos agora, mas vamos focar em 2 principais.

```
~> terraform state list

digitalocean_droplet.workstation
```

```
~> terraform state show digitalocean_droplet.workstation

# digitalocean_droplet.workstation:
resource "digitalocean_droplet" "workstation" {
    backups            = false
    created_at         = "2020-01-02T23:00:56Z"
    disk               = 25
    id                 = "173975496"
    image              = "centos-7-x64"
    ipv4_address       = "138.197.99.100"
    ipv6               = false
    locked             = false
    memory             = 1024
    monitoring         = false
    name               = "TPN"
    price_hourly       = 0.00744
    price_monthly      = 5
    private_networking = false
    region             = "nyc3"
    resize_disk        = true
    size               = "s-1vcpu-1gb"
    ssh_keys           = [
        "35:46:8e:d2:33:5d:27:ce:84:c5:8b:6a:e1:30:aa:50",
    ]
    status             = "active"
    urn                = "do:droplet:173975496"
    vcpus              = 1
    volume_ids         = []
}
```

Voce pode perceber que temos as mesmas informacoes do `cat terraform.tfstate` mas com uma visao mais controlada e apresentavel.


## 1.4.3


#### Precisa compartilhar com outras pessoas.

Suponha que voce esta trabalhando em time ou simplesmente quer utilizar uma ferramenta de CI como GithubAction ou Jenkins. Como voce poderia executar os comandos se o arquivo de estado estiver local?
Uma possivel solucao seria a seguinte:
 * Commitar arquivo 
 * Baixar na ferramenta de CI
 * Executar o apply
 * Commitar o arquivo .tfstate
 * Dar push pro github

Esse formato tem alguns problemas mas provavelmente o maior deles e o fato do arquivo de estado armazenar variaveis como texto plano, entao se voce fizer dessa forma e tiver por exemplo a configuracao de um banco de dados voce vai estar armazenando senhas em texto puro no seu github. E voce nao quer isso nao e?! 

#### Armazena senhas passadas para execução.

Como falamos no topico anterior um dos grandes problemas do arquivo de estado e que ele armazena tudo como texto plano. Se nao estiver enganado o unico backend que podemos utilizar com criptografia por padrao e o Terraform Enterprise mas o custo dele e bem proibitivo inclusive para empresas pequenas.

 Existem algumas solucoes para isso conhecidas como backend. Voce pode armazenar esse arquivo nativamente na AWS, GCP e com um pouco de gambiarra ate mesmo na DigitalOCean.

#### Se você perder o arquivo, vai precisar importar os recursos.

Nesse caso temos 2 opcoes que nao sao excludentes. A primeira e para previnir que isso aconteca e para isso basta utilizarmos um backend como o S3 que nos permite ativar versionamento e fazer varias configuracoes que nos ajudem a perder o arquivo. Mas se ainda assim voce acabar perdendo o arquivo por qualquer motivo a proxima opcao e fazer um import dos recursos, mas ate pra isso e importante saber quais recursos voce vai precisar importar e ter em mente que nem tudo funciona bem com recursos importados.

Eu ja passei por um problema parecido e depois de algumas horas discutindo as solucoes tomamos a decisao de recriar toda a infra novamente, migrar o workload para a nova app e deletar manualmente toda a infra antiga que havia "se perdido".


## 1.4.4 - Importando recursos.

Antes de mais nada vamos verificar que temos um recurso criado.

```
~> terraform state list

digitalocean_droplet.workstation
```

Vamos usar um comando que eu uso muito pouco mas saber que ele existe ja me salvou algumas horas.

```
~> terraform state rm digitalocean_droplet.workstation

Removed digitalocean_droplet.workstation
Successfully removed 1 resource instance(s).
```

Uma coisa que precisa ser observada nesse comando e que nao estamos destruindo um recurso, estamos apenas apagando o registro dele do nosso arquivo de estado. Existem alguns momentos especificos onde isso faz sentido, eu juro, e se um dia voces chegarem nesses momentos (espero que nao precisem) voces vao lembrar que existe e saber como usar.

Mas vamos continuar aqui, vamos olhar nossa pagina de droplets la no digital ocean pra confirmar que nosso recurso ainda esta la.


Beleza, agora vamos tentar importar esse recurso.


E mais simples do que parece, basta ir na documentacao do recurso e geralmente no fim da pagina tem o comando para importar o recurso.
 
 No nosso caso seria algo como:
 
 ```
 terraform import digitalocean_droplet.mydroplet 100823
 ```

Vamos substituir o que precisa ser substituido e executar, no meu caso, o seguinte:

```
~> terraform import digitalocean_droplet.workstation 173989719

digitalocean_droplet.workstation: Importing from ID "173989719"...
digitalocean_droplet.workstation: Import prepared!
  Prepared digitalocean_droplet for import
digitalocean_droplet.workstation: Refreshing state... [id=173989719]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```


Se executarmos novamente o comando de listar todos os recursos veremos exatamente a mesma coisa de antes.

E pra validar melhor ainda vamos destruir o nosso recurso.

```
~> terraform destroy -target digitalocean_droplet.workstation

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

digitalocean_droplet.workstation: Destroying... [id=173989719]
digitalocean_droplet.workstation: Still destroying... [id=173989719, 10s elapsed]
digitalocean_droplet.workstation: Still destroying... [id=173989719, 20s elapsed]
digitalocean_droplet.workstation: Destruction complete after 23s

Warning: Applied changes may be incomplete

The plan was created with the -target option in effect, so some changes
requested in the configuration may have been ignored and the output values may
not be fully updated. Run the following command to verify that no other
changes are pending:
    terraform plan

Note that the -target option is not suitable for routine use, and is provided
only for exceptional situations such as recovering from errors or mistakes, or
when Terraform specifically suggests to use it as part of an error message.


Destroy complete! Resources: 1 destroyed.
```

## 1.4.5 Arquivo remoto

---

[Próximo Capítulo](/modulos/modulo_01/tnp_05.md)

[Início](/README.md)
