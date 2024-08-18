return {
	"nvim-neotest/neotest",
	optional = true,
	dependencies = {
		"shunsambongi/neotest-testthat",
	},
	opts = {
		adapters = {
			["neotest-testthat"] = {},
		},
	},
}
