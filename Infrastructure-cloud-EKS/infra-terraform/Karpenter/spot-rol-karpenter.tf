# This script runs once and won't fail even if the role already exists
resource "null_resource" "create_spot_role_if_not_exists" {
  provisioner "local-exec" {
    command = "aws iam get-role --role-name AWSServiceRoleForEC2Spot || aws iam create-service-linked-role --aws-service-name spot.amazonaws.com"
  }
}
# Wait a moment for the role to propagate
resource "time_sleep" "wait_for_role_propagation" {
  depends_on = [null_resource.create_spot_role_if_not_exists]
  create_duration = "10s"
}
# Once created or verified, we can reference it
data "aws_iam_role" "spot" {
  name = "AWSServiceRoleForEC2Spot"
  depends_on = [time_sleep.wait_for_role_propagation]
}
