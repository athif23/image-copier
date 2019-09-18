const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const HtmlWebPackPlugin = require("html-webpack-plugin");
const devMode = process.env.NODE_ENV !== 'production';

module.exports = {
  plugins: [
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptions.output
      // both options are optional
      filename: devMode ? '[name].css' : '[name].[hash].css',
      chunkFilename: devMode ? '[id].css' : '[id].[hash].css',
    }),
    new HtmlWebPackPlugin({
      filename: "index.html",
      template: "source/index.html"
    })
  ],
  module: {
    rules: [
      {
        test: /\.imba$/,
        loader: 'imba/loader',
      },
      {
        test: /\.html$/,
        use: [
          {
            loader: "html-loader",
            options: { minimize: true }
          }
        ]
      },
      {
        test: /\.(sa|sc|c)ss$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              hmr: process.env.NODE_ENV === 'development',
            },
          },
          'css-loader',
          'sass-loader',
        ],
      },
    ],
  },
  devServer: {
    historyApiFallback: true,
  },
  resolve: {
    extensions: [".imba", ".js", ".json", ".scss"]
  },
  entry: ["./source/index.imba", "./source/index.scss", "./source/index.html"],
  output: {  path: __dirname + '/public', filename: '[name].[contenthash].js' },
  optimization: {
    moduleIds: 'hashed',
    runtimeChunk: 'single',
    splitChunks: {
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all'
        }
      }
    }
  }
}