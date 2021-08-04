/**
 * 输出sdk
 */
const path = require('path')
const config = require('./webpack.base')
const HtmlWebpackPlugin = require('html-webpack-plugin')

Object.assign(config, {
    entry: {
        index: ['./src/index.tsx']
    },
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: `[name].js`,
        publicPath: '/',
    },
    devServer: {
        contentBase: path.join(__dirname, 'dist'),
        port: 9000,
        hot: true,
        bonjour: true,
        host: '0.0.0.0',
        historyApiFallback: true,
    }
})

module.exports = config