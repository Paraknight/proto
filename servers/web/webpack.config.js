var webpack = require('webpack');

module.exports = {
	entry: './proto.ls',
	output: {
		path: __dirname + '/static',
		filename: 'proto.min.js'
	},
	module: {
		loaders: [
			{ test: /\.ls$/, loader: 'livescript' },
			{ test: /\.styl$/, loader: 'style-loader!css-loader!stylus-loader' }
		]
	},
	debug: true,
	devtool: 'source-map',
	plugins: [
		new webpack.optimize.UglifyJsPlugin({
			compress: {
				warnings: false
			},
			sourceMap: true,
			mangle: false
		})
	]
};
