require('webpack');

const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const CompressionWebpackPlugin = require('compression-webpack-plugin');

const entries = {};

glob.sync('./app/javascript/**/main.js').forEach((entry) => {
  const output = entry.replace('./app/javascript/', '').replace(/\.js$/, '');
  entries[output] = entry;
});

module.exports = (env) => ({
  mode: env.development ? 'development' : 'production',
  devtool: 'source-map',
  entry: entries,
  output: {
    filename: '[name]-[contenthash].js',
    sourceMapFilename: '[name]-[contenthash][ext].map',
    path: path.resolve(__dirname, 'public/assets'),
    clean: true,
  },
  optimization: {
    runtimeChunk: 'single',
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
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader'],
      },
      {
        test: /\.s(a|c)ss$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      },
      {
        test: /\.(png)|(jpg)|(jpeg)|(gif)|(bmp)|(svg)$/,
        type: 'asset/resource',
        generator: {
          filename: 'images/[name]-[contenthash][ext]',
        },
      },
      {
        test: /\.(woff)|(woff2)|(ttf)|(eot)$/,
        type: 'asset/resource',
        generator: {
          filename: 'fonts/[name]-[contenthash][ext]',
        },
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '[name]-[contenthash].css' }),
    new CopyWebpackPlugin({
      patterns: [
        {
          from: path.resolve(__dirname, 'node_modules/tinymce/skins'),
          to: path.resolve(__dirname, 'public/assets/admin/components/rich-editor/skins'),
        },
        {
          from: path.resolve(__dirname, 'node_modules/tinymce/plugins'),
          to: path.resolve(__dirname, 'public/assets/admin/components/rich-editor/plugins'),
        },
      ],
    }),
    new CompressionWebpackPlugin(),
  ],
});
