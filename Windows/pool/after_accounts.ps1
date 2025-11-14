$o = new-object -com shell.application
$o.Namespace('\\QNAP').Self.InvokeVerb("pintohome")
