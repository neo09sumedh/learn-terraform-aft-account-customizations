variable "environment" {
    description = "Which environment is this module being called for."
    type = string
}

variable "ous" {
    description = "List of OUs to share the resource with"
    type = map(list(string))
}
