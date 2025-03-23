# Este script se ejecuta una sola vez y no fallará aunque el rol ya exista
resource "null_resource" "create_spot_role_if_not_exists" {
  provisioner "local-exec" {
    command = "aws iam get-role --role-name AWSServiceRoleForEC2Spot || aws iam create-service-linked-role --aws-service-name spot.amazonaws.com"
  }
}

# Espera un momento para que el rol se propague
resource "time_sleep" "wait_for_role_propagation" {
  depends_on = [null_resource.create_spot_role_if_not_exists]
  create_duration = "10s"
}

# Una vez creado o verificado, podemos referenciarlo
data "aws_iam_role" "spot" {
  name = "AWSServiceRoleForEC2Spot"
  depends_on = [time_sleep.wait_for_role_propagation]
}
