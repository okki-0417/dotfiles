-- TypeScript / JavaScript
local shared = {
  updateImportsOnFileMove = { enabled = "always" },         -- js/ts.updateImportsOnFileMove.enabled
  preferences = { importModuleSpecifier = "non-relative" },  -- js/ts.preferences.importModuleSpecifier
  inlayHints = {
    parameterNames = { enabled = "literals" },
    variableTypes = { enabled = false },
  },
}

return {
  settings = {
    typescript = shared,
    javascript = shared,
    vtsls = {
      autoUseWorkspaceTsdk = true, -- プロジェクトの node_modules/typescript を使う
      experimental = { completion = { enableServerSideFuzzyMatch = true } },
    },
  },
}
