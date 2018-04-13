# Hands on Terraform

Cet ensemble d'exercices a été initié pour une session donnée à Devoxx 2018. Pour dérouler ce hands-on
vous aurez besoin de vous munir de :

* vos clés d'API AWS
* binaire Terraform ([installer](https://www.terraform.io/downloads.html))
* un éditeur de code. Si vous n'avez pas de préférence, nous vous conseillons [Pycharm](https://www.jetbrains.com/pycharm/download/#section=linux)
additionné du plugin [Terraform/HCL](https://plugins.jetbrains.com/plugin/7808-hashicorp-terraform--hcl-language-support)


## Step 0 : Provider AWS

Il s'agit de valider que vous avez bien accès à votre compte AWS via vos clés d'API.

* Suivez le [guide de configuration du provider](https://www.terraform.io/docs/providers/aws/). Nous vous conseillons de prendre
l'option `Environment variables` puisque c'est celle que nous avons prise. Les autres risquent de vous forcer à éditer du
code à chaque étape.

* Placez vous dans le répertoire `step-0`

* Lancez les commandes:
```
terraform init
terraform plan
```

Vous devriez voir une sortie identique à celle-ci :
```
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
```

Si c'est le cas, Terraform arrive à s'authentifier auprès d'AWS. Bravo.

## Step 1 : Réseau

Nous allons maintenant déployer le réseau nécessaire pour notre projet.

* Placez vous dans le répertoire `step-1`

* Lancez la commande `terraform init`

* Parcourez attentivement et effectuez les TODO contenus dans les fichiers :

  * `providers.tf`
  * `variables.tf`

* Si vous faites les choses bien vous devriez être en mesure de lancer successivement:

```
terraform plan
terraform apply
```

Si c'est le cas