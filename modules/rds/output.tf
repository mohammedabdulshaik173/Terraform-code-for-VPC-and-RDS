output "data_subnet_ids" {
  value = data.aws_subnet_ids.available_db_subnet.ids
}