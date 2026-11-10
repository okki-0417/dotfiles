-- Tailwind の @apply / @tailwind などを未知の at-rule として警告しない
return {
  settings = {
    css = { lint = { unknownAtRules = "ignore" } },
  },
}
