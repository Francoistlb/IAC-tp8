plugin "terraform" {
  enabled = true
  version = "0.1.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"

  rules {
    # Ignorer les variables non utilisées pour la sécurité
    terraform_unused_declarations = {
      enabled = false
    }
  }
}

plugin "aws" {
  enabled = false
}
