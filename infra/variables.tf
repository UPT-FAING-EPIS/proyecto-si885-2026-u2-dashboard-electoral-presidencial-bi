variable "project_name" {
  description = "Nombre corto del proyecto. Solo letras minusculas y numeros."
  type        = string
  default     = "candidatos2026"
}

variable "environment" {
  description = "Ambiente de despliegue."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Region de Azure."
  type        = string
  default     = "eastus"
}

variable "sql_location" {
  description = "Region especifica para Azure SQL. Algunas suscripciones estudiantiles restringen SQL por region."
  type        = string
  default     = null
}

variable "sql_admin_login" {
  description = "Usuario administrador de Azure SQL."
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "Password del administrador de Azure SQL."
  type        = string
  sensitive   = true
}

variable "allowed_ip_address" {
  description = "IP publica autorizada para conectarse a Azure SQL. Usar 0.0.0.0 solo para pruebas controladas."
  type        = string
  default     = "0.0.0.0"
}

variable "sql_database_sku" {
  description = "SKU de Azure SQL Database."
  type        = string
  default     = "Basic"
}
