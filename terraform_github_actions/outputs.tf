output "db_instance_endpoint" {
  value       = aws_db_instance.dittodb.endpoint
  description = "The connection endpoint for the database instance."
}