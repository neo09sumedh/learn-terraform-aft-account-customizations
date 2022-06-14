variable "environments" {
    description = ""
    type = map(string)
    default = {
        dev = "",
        prd = ""
    }
}

variable "ous" {
    description = ""
    type = map(list(string))
    default = {
        dev = ["arn:aws:organizations::925395589051:ou/o-hyyzavlm7a/ou-4uhe-u1avwiyp"],
        prd = ["arn:aws:organizations::925395589051:ou/o-hyyzavlm7a/ou-4uhe-xabhcjk2"]
    }
}
