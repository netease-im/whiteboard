const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

module.exports = {
  entry: {
    main: './src/index.tsx'
  },
  output: {
    filename: '[name].[contenthash:8].js',
    path: path.resolve(__dirname, 'dist', 'assets'),
    publicPath: '/'
  },
  resolve: {
    extensions: ['.js', '.ts', '.tsx', '.json']
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: [
          'babel-loader',
          'ts-loader'
        ],
        exclude: /node_modules/
      },
      {
        test: /\.less$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'less-loader'
        ]
      },
      {
        test: /\.(svg|woff|woff2|ttf|eot|png|jpg|jpeg|gif)(\?v=\d+\.\d+\.\d+)?$/i,
        type: 'asset/resource'
      }
    ]
  },
  mode: 'development',
  externals: {
    WhiteBoardSDK: 'WhiteBoardSDK',
    ToolCollection: 'ToolCollection'
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: '[name].css',
      chunkFilename: '[id].css'
    }),
    new HtmlWebpackPlugin({
      template: path.resolve(__dirname, 'index.html'),
      publicPath: '/'
    })
  ],
  devServer: {
    historyApiFallback: true,
    static: {
      directory: path.join(__dirname, 'dist'),
    },
    open: true
  },
  performance: {
    hints: false,
  }
}
