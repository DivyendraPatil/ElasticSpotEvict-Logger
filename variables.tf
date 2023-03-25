variable "enable" {
  default = true
}

variable "log_retention" {
  description = "number of days to retain cloudwatch logs for lambda function"
  default     = 14
}

variable "timeout" {
  description = "Lambda timeout"
  default     = 120
}

variable "memory" {
  description = "amount of memory to allocate"
  default     = 128
}

variable "lambda_environment" {
  default = {
    NOENV = "NOENV"
  }
}

variable "spot-evict-event-role-name" {
  default = "spot-evict-event.role"
}

variable "SpotEvictionEventLambda" {
  description = "Prefix for created resources"
  default     = "SpotEvictionEventLambda"
}

variable "spot-evict-event-zip" {
  description = "Name of zip file containing lambda code"
  default     = "spot-evict-event.zip"
}

variable "spot-evict-event" {
  description = "Name of handler function"
  default     = "spot-evict-event"
}

