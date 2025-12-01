output "wordpress_ami_id" {
  description = "The ID of the latest WordPress AMI found."
  # Reference the data source's ID here
  value = data.aws_ami.wordpress_image.id
}
