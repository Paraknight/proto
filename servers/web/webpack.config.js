var webpack = require('webpack');

module.exports = {
	entry: './proto.ls',
	output: {
		path: __dirname + '/static',
		filename: 'proto.min.js'
	},
	module: {
		loaders: [
			{ test: /\.ls$/, loader: 'livescript' }
		]
	},
	plugins: [
		new webpack.optimize.UglifyJsPlugin({
			compress: {
				warnings: false
			},
			sourceMap: true
		})
	]
};
