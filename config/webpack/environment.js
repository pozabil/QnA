const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  	new webpack.ProvidePlugin({
    	$: 'jquery/src/jquery',
    	jQuery: 'jquery/src/jquery',
    	_: "underscore/underscore",
    	Gh3: "gh3/gh3"
  	})
)

module.exports = environment
