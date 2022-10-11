#configure aws
#add openID connect provider
resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [ "sts.amazonaws.com" ]

  #code from github docs for aws openID connection
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

#create a policy document to allow github acctions
data "aws_iam_policy_document" "github_assume_role_policy" {
    statement {
        sid = "github"
        actions = ["sts:AssumeRoleWithWebIdentity"]
        principals {
          type = "Federated"
          identifiers = [aws_iam_openid_connect_provider.default.arn]
        }
        condition {
            test = "StringEquals"
            variable = "token.actions.githubusercontent.com:aud"
            values = ["sts.amazonaws.com"]
        }
        condition {
            test = "StringLike"
            variable = "token.actions.githubusercontent.com:sub"
            #allow for my github account all repos to ues github acctions
            #can specify even whih repo can do this, instead of all
            values = ["repo:olga-matusik/*:*"]
        }
    }
}

#create a new role
resource "aws_iam_role" "github_actions" {
  name               = "github-actions-oidc"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role_policy.json
}

#attach the policy to the role
#AdministratorAccess -full power for github actions -> not on client account!!!
resource "aws_iam_role_policy_attachment" "github_actions_atch" {
    role = aws_iam_role.github_actions.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}