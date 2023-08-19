require('webpack');

const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserWebpackPlugin = require('terser-webpack-plugin');

const entries = {};

glob.sync('./app/javascript/**/main.js').forEach((entry) => {
  const output = entry.replace('app/javascript/', '').replace(/\.js$/, '');
  entries[output] = `./${entry}`;
});

module.exports = (env) => ({
  mode: env.development ? 'development' : 'production',
  devtool: env.development ? 'eval' : 'source-map',
  entry: entries,
  output: {
    filename: '[name].js',
    chunkFilename: '[name]-[contenthash].digested.js',
    sourceMapFilename: '[name]-[contenthash].digested[ext].map',
    path: path.resolve(__dirname, 'app/assets/builds'),
    clean: true,
  },
  optimization: {
    runtimeChunk: 'single',
    minimize: !env.development,
    minimizer: [
      new TerserWebpackPlugin({
        extractComments: {
          filename: ({ filename, hash }) => (
            filename.indexOf('.digested.') < 0 ? `${filename}-${hash}.digested.LICENSE.txt` : `${filename}.LICENSE.txt`
          ),
        },
      }),
    ],
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'],
            plugins: ['@babel/plugin-transform-runtime'],
          },
        },
        generator: {
          filename: '[name]-[contenthash].digested.js',
        },
      },
      {
        test: /\.css$/,
        exclude: /tinymce\/(.+)\/content\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader'],
      },
      {
        test: /tinymce\/(.+)\/content\.css$/,
        type: 'asset/source',
      },
      {
        test: /\.s(a|c)ss$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      },
      {
        test: /\.(png)|(jpg)|(jpeg)|(gif)|(bmp)|(svg)$/,
        type: 'asset/resource',
        generator: {
          filename: 'images/[name]-[contenthash].digested[ext]',
        },
      },
      {
        test: /\.(woff)|(woff2)|(ttf)|(eot)$/,
        type: 'asset/resource',
        generator: {
          filename: 'fonts/[name]-[contenthash].digested[ext]',
        },
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: '[name].css',
      chunkFilename: '[name]-[contenthash].digested.css',
    }),
  ],
});
