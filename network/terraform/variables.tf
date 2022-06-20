variable "environments" {
    description = ""
    type = map(string)
    default = {
        dev = "",
        prd = ""
    }
}

